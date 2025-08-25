import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mood_tracker_assessment/src/domain/entities/api_response.dart';
import 'package:mood_tracker_assessment/src/domain/repository/connectivity_repository.dart';

final connectivityRepositoryProvider = Provider<ConnectivityRepository>((ref) {
  return ConnectivityRepositoryImpl();
});

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  // leveraging on the InternetConnectionChecker package because it not just check the connectivity status but also checks for poor data connection
  Future<bool> _checkConnectivity() async {
    try {
      return InternetConnection().hasInternetAccess;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiResponse<T>> executeWithConnectivityCheck<T>({
    required Future<ApiResponse<T>> Function() networkCall,
    int maxAttempts = 3,
    Duration retryDelay = const Duration(seconds: 2),
    String? operationName,
  }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      attempts++;

      // Check connectivity before each attempt
      final hasConnection = await _checkConnectivity();
      if (!hasConnection) {
        if (attempts == maxAttempts) {
          return ApiResponse.error(
            'No internet connection available. Please check your network and try again.',
            isNetworkError: true,
          );
        } else {
          print('[I AM RETRYING] ${operationName ?? 'Network call'} - No connection, attempt $attempts/$maxAttempts');
          await Future.delayed(retryDelay);
          continue;
        }
      }

      try {
        // Attempt the network call
        final result = await networkCall();

        // If successful or it's a non-retryable error, return the result
        if (result.isSuccess || !_shouldRetryError(result)) {
          return result;
        }

        // If it's a retryable error and we have more attempts, retry
        if (attempts < maxAttempts) {
          print('[RETRY] ${operationName ?? 'Network call'} failed, attempt $attempts/$maxAttempts: ${result.error}');
          await Future.delayed(Duration(seconds: retryDelay.inSeconds * attempts));
          continue;
        }

        return result;
      } catch (e) {
        if (attempts >= maxAttempts) {
          return _handleException(e);
        }
        print('[RETRY] ${operationName ?? 'Network call'} exception, attempt $attempts/$maxAttempts: $e');
        await Future.delayed(Duration(seconds: retryDelay.inSeconds * attempts));
      }
    }

    return ApiResponse.error('Network request failed after $maxAttempts attempts', isNetworkError: true);
  }

  bool _shouldRetryError<T>(ApiResponse<T> response) {
    if (response.isSuccess) return false;

    // if there is network error, return true to retry
    if (response.isNetworkError == true) return true;

    // i am retrying based on error message, i can also retry from status code
    final errorMessage = response.error?.toLowerCase() ?? '';
    final statusCodeBad = [408, 429, 500, 502, 503, 504].contains(response.statusCode);
    return statusCodeBad ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('network') ||
        errorMessage.contains('server error') ||
        errorMessage.contains('503') ||
        errorMessage.contains('502') ||
        errorMessage.contains('504');
  }

  ApiResponse<T> _handleException<T>(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return ApiResponse.error('Connection timeout. Please check your internet connection.', isNetworkError: true);
        case DioExceptionType.sendTimeout:
          return ApiResponse.error('Request timeout. Please try again.', isNetworkError: true);
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error('Server response timeout. Please try again.', isNetworkError: true);
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          if (statusCode != null) {
            switch (statusCode) {
              case 400:
                return ApiResponse.error('Bad request. Please check your input.', statusCode: statusCode);
              case 401:
                return ApiResponse.error('Unauthorized. Please login again.', statusCode: statusCode);
              case 403:
                return ApiResponse.error('Access forbidden.', statusCode: statusCode);
              case 404:
                return ApiResponse.error('Resource not found.', statusCode: statusCode);
              case 500:
                return ApiResponse.error(
                  'Server error. Please try again later.',
                  statusCode: statusCode,
                  isNetworkError: true,
                );
              default:
                return ApiResponse.error(
                  'Request failed with status code: $statusCode',
                  statusCode: statusCode,
                  isNetworkError: statusCode >= 500,
                );
            }
          }
          return ApiResponse.error('Request failed. Please try again.', isNetworkError: true);
        case DioExceptionType.cancel:
          return ApiResponse.error('Request was cancelled.', isNetworkError: true);
        case DioExceptionType.connectionError:
          return ApiResponse.error('Connection error. Please check your internet connection.', isNetworkError: true);
        case DioExceptionType.badCertificate:
          return ApiResponse.error('Security certificate error.', isNetworkError: true);
        case DioExceptionType.unknown:
          return ApiResponse.error(e.message ?? 'An unexpected error occurred.', isNetworkError: true);
      }
    } else if (e is SocketException) {
      return ApiResponse.error('No internet connection. Please check your network.', isNetworkError: true);
    } else {
      return ApiResponse.error('An unexpected error occurred: ${e.toString()}');
    }
  }
}
