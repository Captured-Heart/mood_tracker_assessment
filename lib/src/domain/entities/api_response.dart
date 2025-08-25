class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? metadata;
  final bool isNetworkError;

  const ApiResponse._({
    required this.isSuccess,
    this.data,
    this.error,
    this.statusCode,
    this.metadata,
    this.isNetworkError = false,
  });

  factory ApiResponse.success(T data, {int? statusCode, Map<String, dynamic>? metadata}) {
    return ApiResponse._(isSuccess: true, data: data, statusCode: statusCode, metadata: metadata);
  }

  factory ApiResponse.error(
    String error, {
    int? statusCode,
    Map<String, dynamic>? metadata,
    bool isNetworkError = false,
  }) {
    return ApiResponse._(
      isSuccess: false,
      error: error,
      statusCode: statusCode,
      metadata: metadata,
      isNetworkError: isNetworkError,
    );
  }

  /// Check if the response is successful
  bool get hasData => isSuccess && data != null;

  /// Check if the response has an error
  bool get hasError => !isSuccess;

  /// Get data with null safety
  T? get safeData => isSuccess ? data : null;

  /// Get error message with fallback
  String get errorMessage => error ?? 'Unknown error occurred';

  /// Handle the response with callbacks
  R when<R>({required R Function(T data) success, required R Function(String error) failure}) {
    if (isSuccess && data != null) {
      return success(data as T);
    } else {
      return failure(errorMessage);
    }
  }

  /// Map the success data to another type
  ApiResponse<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      try {
        final mappedData = mapper(data as T);
        return ApiResponse.success(mappedData, statusCode: statusCode, metadata: metadata);
      } catch (e) {
        return ApiResponse.error('Data mapping failed: ${e.toString()}', statusCode: statusCode);
      }
    } else {
      return ApiResponse.error(errorMessage, statusCode: statusCode, metadata: metadata);
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse.success(data: $data, statusCode: $statusCode)';
    } else {
      return 'ApiResponse.error(error: $error, statusCode: $statusCode)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse<T> &&
        other.isSuccess == isSuccess &&
        other.data == data &&
        other.error == error &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return isSuccess.hashCode ^ data.hashCode ^ error.hashCode ^ statusCode.hashCode;
  }
}
