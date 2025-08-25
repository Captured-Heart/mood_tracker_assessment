import 'package:mood_tracker_assessment/src/domain/entities/api_response.dart';

abstract class ConnectivityRepository {
  Future<ApiResponse<T>> executeWithConnectivityCheck<T>({
    required Future<ApiResponse<T>> Function() networkCall,
    int maxAttempts = 3,
    Duration retryDelay = const Duration(seconds: 2),
    String? operationName,
  });
}
