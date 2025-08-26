import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mood_tracker_assessment/constants/dio_exception_handler.dart';
import 'package:mood_tracker_assessment/src/domain/entities/api_response.dart';
import 'package:mood_tracker_assessment/src/domain/repository/network/connectivity_repository.dart';

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
        if (result.isSuccess || !DioExceptionHandler.shouldRetryError(result)) {
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
          return DioExceptionHandler.handleDioException<T>(e);
        }
        print('[RETRY] ${operationName ?? 'Network call'} exception, attempt $attempts/$maxAttempts: $e');
        await Future.delayed(Duration(seconds: retryDelay.inSeconds * attempts));
      }
    }

    return ApiResponse.error('Network request failed after $maxAttempts attempts', isNetworkError: true);
  }

  @override
  Stream<InternetStatus> internetStatus() {
    return InternetConnection().onStatusChange;
  }
}
