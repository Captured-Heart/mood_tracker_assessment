import 'package:dio/dio.dart';
import 'package:mood_tracker_assessment/src/domain/entities/api_response.dart';

// My DIO exception handler

class DioExceptionHandler {
  /// Convert Dio exceptions to ApiResponse
  static ApiResponse<T> handleDioException<T>(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return ApiResponse.error(
            'Connection timeout. Please check your internet connection.',
            statusCode: e.response?.statusCode,
            isNetworkError: true,
          );
        case DioExceptionType.sendTimeout:
          return ApiResponse.error(
            'Request timeout. Please try again.',
            statusCode: e.response?.statusCode,
            isNetworkError: true,
          );
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error(
            'Server response timeout. Please try again.',
            statusCode: e.response?.statusCode,
            isNetworkError: true,
          );
        case DioExceptionType.badResponse:
          return _handleBadResponse<T>(e);
        case DioExceptionType.cancel:
          return ApiResponse.error('Request was cancelled.', isNetworkError: false);
        case DioExceptionType.connectionError:
          return ApiResponse.error(
            'Connection error. Please check your internet connection.',
            statusCode: e.response?.statusCode,
            isNetworkError: true,
          );
        case DioExceptionType.badCertificate:
          return ApiResponse.error(
            'Security certificate error.',
            statusCode: e.response?.statusCode,
            isNetworkError: true,
          );
        case DioExceptionType.unknown:
          return ApiResponse.error(
            e.message ?? 'An unexpected error occurred.',
            statusCode: e.response?.statusCode,
            isNetworkError: true,
          );
      }
    }

    // Handle non-DioException errors
    return ApiResponse.error('An unexpected error occurred: ${e.toString()}', isNetworkError: false);
  }

  /// Handle bad response errors with detailed status code mapping
  static ApiResponse<T> _handleBadResponse<T>(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    String message = e.message ?? 'Request failed';

    // Try to extract message from response data
    if (responseData != null) {
      if (responseData is Map<String, dynamic>) {
        message = responseData['message'] ?? responseData['error'] ?? responseData['detail'] ?? message;
      } else if (responseData is String) {
        message = responseData;
      }
    }

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return ApiResponse.error(
            message.isEmpty ? 'Bad request. Please check your input.' : message,
            statusCode: statusCode,
            isNetworkError: false,
          );
        case 401:
          return ApiResponse.error(
            message.isEmpty ? 'Unauthorized. Please login again.' : message,
            statusCode: statusCode,
            isNetworkError: false,
          );
        case 403:
          return ApiResponse.error(
            message.isEmpty ? 'Access forbidden.' : message,
            statusCode: statusCode,
            isNetworkError: false,
          );
        case 404:
          return ApiResponse.error(
            message.isEmpty ? 'Resource not found.' : message,
            statusCode: statusCode,
            isNetworkError: false,
          );
        case 409:
          return ApiResponse.error(
            message.isEmpty ? 'Conflict. Resource already exists.' : message,
            statusCode: statusCode,
            isNetworkError: false,
          );
        case 422:
          return ApiResponse.error(
            message.isEmpty ? 'Validation failed. Please check your input.' : message,
            statusCode: statusCode,
            isNetworkError: false,
          );
        case 429:
          return ApiResponse.error(
            message.isEmpty ? 'Too many requests. Please try again later.' : message,
            statusCode: statusCode,
            isNetworkError: true, // Retryable
          );
        case 500:
          return ApiResponse.error(
            message.isEmpty ? 'Internal server error. Please try again later.' : message,
            statusCode: statusCode,
            isNetworkError: true,
          );
        case 502:
          return ApiResponse.error(
            message.isEmpty ? 'Bad gateway. Please try again later.' : message,
            statusCode: statusCode,
            isNetworkError: true,
          );
        case 503:
          return ApiResponse.error(
            message.isEmpty ? 'Service unavailable. Please try again later.' : message,
            statusCode: statusCode,
            isNetworkError: true,
          );
        case 504:
          return ApiResponse.error(
            message.isEmpty ? 'Gateway timeout. Please try again later.' : message,
            statusCode: statusCode,
            isNetworkError: true,
          );
        default:
          final isServerError = statusCode >= 500;
          return ApiResponse.error(
            message.isEmpty ? 'Request failed with status code: $statusCode' : message,
            statusCode: statusCode,
            isNetworkError: isServerError,
          );
      }
    }

    return ApiResponse.error(
      message.isEmpty ? 'Request failed. Please try again.' : message,
      statusCode: statusCode,
      isNetworkError: true,
    );
  }

  // when to retry
  static bool shouldRetryError<T>(ApiResponse<T> response) {
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

  // log messages
  static String getLogMessage(dynamic e) {
    if (e is DioException) {
      final method = e.requestOptions.method;
      final path = e.requestOptions.path;
      final statusCode = e.response?.statusCode ?? 'unknown';
      return '[${e.type.name.toUpperCase()}] $method $path - Status: $statusCode - ${e.message ?? 'No message'}';
    }
    return '[ERROR] ${e.toString()}';
  }
}
