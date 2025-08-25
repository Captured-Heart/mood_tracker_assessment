import 'package:flutter/foundation.dart';

/// API Constants and Configuration
class ApiConstants {
  // Environment
  static const bool isDevelopment = kDebugMode;
  static const bool isProduction = false;

  // API URLs
  static const String baseUrl = 'https://openlibrary.org';
  // static const String authUrl = '';

  // Request Configuration
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Retry Configuration
  static const int maxRetries = 3;
  static const List<Duration> retryDelays = [Duration(seconds: 1), Duration(seconds: 3), Duration(seconds: 5)];

  // Security
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tokenExpiryKey = 'token_expiry';

  // Headers
  static const Map<String, String> defaultHeaders = {'Content-Type': 'application/json', 'Accept': 'application/json'};

  // Error Messages
  static const String networkError = 'Network connection failed. Please check your internet.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String authError = 'Authentication failed. Please login again.';
}
