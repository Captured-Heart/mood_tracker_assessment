import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mood_tracker_assessment/constants/api_constants.dart';
import 'package:mood_tracker_assessment/src/data/repository/network/token_repository_impl.dart';
import 'package:mood_tracker_assessment/src/domain/repository/dio_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/token_repository.dart';

final dioRepositoryProvider = Provider<DioRepository>((ref) {
  final tokenRepository = ref.read(tokenRepositoryProvider);
  return DioRepositoryImpl(tokenRepository);
});

class DioRepositoryImpl extends DioRepository {
  late Dio _dio;
  bool _isInitialized = false;
  final TokenRepository _tokenService;

  DioRepositoryImpl(this._tokenService);

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: ApiConstants.defaultHeaders,
      ),
    );

    await _setupInterceptors();
    _isInitialized = true;
  }

  //! ---------- ADD AUTH TOKENS -----------------
  /// Add authentication token to requests
  Future<void> _addAuthToken(RequestOptions options) async {
    try {
      final token = await _tokenService.getValidToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      print('[AUTH] Failed to add token: $e');
    }
  }

  //! ------  SET UP INTERCEPTORS ---------------
  ///? I setup all interceptors for security, retry, and logging
  Future<void> _setupInterceptors() async {
    // 1. Token Interceptor - i automatically adds auth tokens in request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _addAuthToken(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          handler.next(response);
        },
        onError: (error, handler) async {
          await _handleError(error, handler);
        },
      ),
    );

    // 2. Retry Interceptor - Handles network failures and retries
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) => print('[RETRY] $message'),
        retries: ApiConstants.maxRetries,
        retryDelays: ApiConstants.retryDelays,
        retryEvaluator: (error, attempt) {
          // Retry on network errors, timeouts, and server errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError) {
            print('[RETRY] Network error, attempt $attempt');
            return true;
          }

          if (error.response?.statusCode != null) {
            final statusCode = error.response!.statusCode!;
            // i can also retry here based on any status code
            if (statusCode >= 500 && statusCode < 600) {
              print('[RETRY] Server error $statusCode, attempt $attempt');
              return true;
            }
          }

          return false;
        },
      ),
    );

    // 3. Logging Interceptor - i am logging requests and responses in development mode
    if (ApiConstants.isDevelopment) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (object) => print('[DIO] $object'),
        ),
      );
    }
  }

  //! --------- LOG THE RESPONSES ------------------
  void _logResponse(Response response) {
    if (ApiConstants.isDevelopment) {
      print('[API] ${response.requestOptions.method} ${response.requestOptions.path} - ${response.statusCode}');
    }
  }

  // ! ------------ HANDLE ERRORS ---------------
  Future<void> _handleError(DioException error, ErrorInterceptorHandler handler) async {
    print('[ERROR] ${error.type}: ${error.message}');

    // checkk if token is expired
    if (error.response?.statusCode == 401) {
      try {
        final refreshed = await _tokenService.refreshToken();
        if (refreshed) {
          final options = error.requestOptions;
          await _addAuthToken(options);
          final response = await _dio.fetch(options);
          handler.resolve(response);
          return;
        } else {
          // if i can't refresh the token, i clear it and ask user to login again
          await _tokenService.clearTokens();
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: 'Authentication failed. Please login again.',
              type: DioExceptionType.unknown,
            ),
          );
          return;
        }
      } catch (e) {
        print('[AUTH] Token refresh failed: $e');
      }
    }

    // Handle network connectivity issues
    if (error.type == DioExceptionType.connectionError) {
      final hasConnection = await _checkConnectivity();
      if (!hasConnection) {
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: 'No internet connection. Please check your network.',
            type: DioExceptionType.connectionError,
          ),
        );
        return;
      }
    }

    handler.next(error);
  }

  // leveraging on the InternetConnectionChecker package because it not just check the connectivity status but also checks for poor data connection
  Future<bool> _checkConnectivity() async {
    try {
      return InternetConnection().hasInternetAccess;
    } catch (e) {
      return false;
    }
  }
}
