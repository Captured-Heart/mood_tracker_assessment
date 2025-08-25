import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/dio_exception_handler.dart';
import 'package:mood_tracker_assessment/src/domain/entities/api_response.dart';
import 'package:mood_tracker_assessment/src/domain/repository/network/connectivity_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/network/dio_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/network/network_calls_repository.dart';
import 'package:mood_tracker_assessment/src/data/repository/network/connectivity_repo_impl.dart';
import 'package:mood_tracker_assessment/src/data/repository/network/dio_repository_impl.dart';

final networkCallsRepositoryProvider = Provider<NetworkCallsRepository>((ref) {
  final dioRepository = ref.read(dioRepositoryProvider);
  final connectivityRepository = ref.read(connectivityRepositoryProvider);
  return NetworkCallsRepositoryImplementation(dioRepository, connectivityRepository);
});

class NetworkCallsRepositoryImplementation implements NetworkCallsRepository {
  final DioRepository _dioRepository;
  final ConnectivityRepository _connectivityRepository;

  NetworkCallsRepositoryImplementation(this._dioRepository, this._connectivityRepository);

  @override
  Future<ApiResponse<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return await _connectivityRepository.executeWithConnectivityCheck<T>(
      networkCall: () async {
        try {
          final response = await _dioRepository.get<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          );
          // Handle successful response
          if (response.statusCode == 200) {
            return ApiResponse.success(response.data as T, statusCode: response.statusCode);
          } else {
            return ApiResponse.error('Failed to load data', statusCode: response.statusCode);
          }
        } catch (e) {
          return DioExceptionHandler.handleDioException<T>(e);
        }
      },
      operationName: 'GET $path',
    );
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return await _connectivityRepository.executeWithConnectivityCheck<T>(
      networkCall: () async {
        try {
          final response = await _dioRepository.post<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          return ApiResponse.success(response.data as T, statusCode: response.statusCode);
        } catch (e) {
          return DioExceptionHandler.handleDioException<T>(e);
        }
      },
      operationName: 'POST $path',
    );
  }

  @override
  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return await _connectivityRepository.executeWithConnectivityCheck<T>(
      networkCall: () async {
        try {
          final response = await _dioRepository.put<T>(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          return ApiResponse.success(response.data as T, statusCode: response.statusCode);
        } catch (e) {
          return DioExceptionHandler.handleDioException<T>(e);
        }
      },
      operationName: 'PUT $path',
    );
  }
}
