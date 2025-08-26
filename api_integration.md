# Mood Tracker App - Secure API Architecture

This document explains how the Mood Tracker app implements a robust, secure API communication system using token-based authentication, comprehensive error handling, retry mechanisms, and offline mode support.

## Architecture Overview

The app uses a layered architecture with four main components working together to provide secure API communications:

1. **TokenService (TokenRepositoryImpl)** - Handles secure token management and authentication
2. **DioRepositoryImpl** - Manages HTTP client configuration with interceptors and security
3. **NetworkCallsRepositoryImpl** - Orchestrates API calls with connectivity checks and error handling
4. **ConnectivityRepositoryImpl** - Provides network connectivity management for offline mode

---

## 1. TokenService (TokenRepositoryImpl) - Secure Token Management

### Core Responsibilities

- **Secure Token Storage**: Uses Flutter Secure Storage with platform-specific encryption
- **Token Integrity Validation**: Implements SHA-256 hashing for tamper detection
- **Automatic Token Refresh**: Handles token expiration transparently
- **Authentication State Management**: Provides centralized authentication status

### Security Features

#### Encrypted Storage Configuration

```dart
static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'mood_tracker_secure_prefs',
    preferencesKeyPrefix: 'mt_',
  ),
  iOptions: IOSOptions(
    groupId: 'group.com.mood_tracker.app',
    accountName: 'mood_tracker_tokens',
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);
```

#### Multi-Layer Encryption

- **Platform Security**: Leverages Android Keystore and iOS Keychain
- **Application Encryption**: Additional Base64 encoding layer
- **Token Integrity**: SHA-256 hash validation to detect tampering

#### Token Lifecycle Management

- **Storage**: Encrypts tokens before storing with expiration metadata
- **Retrieval**: Validates integrity and expiration before returning tokens
- **Refresh**: Automatically refreshes expired tokens using refresh token
- **Cleanup**: Securely clears all tokens on authentication failure

### Key Methods

|                      |                                                           |
| -------------------- | --------------------------------------------------------- |
| `storeTokens()`:     | Encrypts and stores access/refresh tokens with expiration |
| `getValidToken()`:   | Returns valid token or refreshes if expired               |
| `refreshToken()`:    | Automatically refreshes expired access tokens             |
| `isAuthenticated()`: | Checks if user has valid authentication                   |
| `clearTokens()`:     | Securely removes all stored tokens                        |

---

## 2. DioRepositoryImpl - HTTP Client & Security Layer

### Core Responsibilities

- **HTTP Client Configuration**: Configures Dio with timeouts, headers, and base URL
- **Security Interceptors**: Automatically adds authentication tokens to requests
- **Token Refresh Handling**: Intercepts 401 errors and refreshes tokens
- **Retry Logic**: Implements smart retry for network and server errors
- **Request/Response Logging**: Development-mode logging for debugging

### Security Implementation

#### Automatic Token Injection

```dart
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      await _addAuthToken(options); // Automatically adds Bearer token
      handler.next(options);
    },
  ),
);
```

#### Error Handling

- **401 Unauthorized**: Automatically attempts token refresh
- **Network Errors**: Checks connectivity and retries appropriate errors
- **Server Errors (5xx)**: Implements exponential backoff retry strategy
- **Token Integrity**: Validates token before each request

#### Retry Strategy Configuration

```dart
RetryInterceptor(
  dio: _dio,
  retries: ApiConstants.maxRetries, // i set the attempts here
  retryDelays: [1s, 3s, 5s], // you can set it
  retryEvaluator: (error, attempt) {
    // Retry on network issues, timeouts, and server errors
    return shouldRetryBasedOnError(error);
  },
);
```

### Interceptor Chain

1. **Token Interceptor**: Adds authentication headers
2. **Retry Interceptor**: Handles transient failures
3. **Logging Interceptor**: Development debugging (disabled in production)
4. **Error Interceptor**: Comprehensive error handling and token refresh

---

## 3. NetworkCallsRepositoryImpl

### Core Responsibilities

- **API Call Coordination**: Orchestrates Dio operations with connectivity checks
- **Error Standardization**: Converts all errors to standardized `ApiResponse<T>`
- **Offline Mode Support**: handles the network unavailability

### Connectivity Integration

```dart
return await _connectivityRepository.executeWithConnectivityCheck<T>(
  networkCall: () async {
    // I make the API calls here using DioRepository
  },
  maxAttempts: 3,
  retryDelay: Duration(seconds: 2),
  operationName: 'GET $path',
);
```

### Error Handling Flow

1. **First Step**: Validates internet connectivity
2. **API Execution**: Performs HTTP request via DioRepository
3. **Error Processing**: Converts exceptions to standardized responses
4. **Retry Logic**: Implements connectivity-aware retry attempts
5. **Fallback Handling**: Provides meaningful offline mode responses

---

## 4. ConnectivityRepositoryImpl - Network Connectivity Management

### Core Responsibilities

- **Real-time Connectivity Monitoring**: Monitors internet connection status in real-time
- **Pre-flight Connection Validation**: Verifies connectivity before executing network calls
- **Connection Quality Assessment**: Goes beyond basic connectivity to check actual internet access
- **Network State Streaming**: Provides real-time connectivity status updates to the application

### Advanced Connectivity Features

#### Internet Connection Checker Plus Integration

```dart
Future<bool> _checkConnectivity() async {
  try {
    return InternetConnection().hasInternetAccess; // Actual internet access check
  } catch (e) {
    return false;
  }
}
```

**Why Internet Connection Checker Plus?**

- **Beyond Basic Connectivity**: Doesn't just check if device is connected to WiFi/cellular
- **Real Internet Access**: Actually tests if device can reach the internet
- **Poor Connection Detection**: Identifies weak or unstable connections
- **Cross-Platform Consistency**: Works reliably on both iOS and Android

#### Retry Strategy

The `executeWithConnectivityCheck` method implements a sophisticated retry mechanism:

```dart
Future<ApiResponse<T>> executeWithConnectivityCheck<T>({
  required Future<ApiResponse<T>> Function() networkCall,
  int maxAttempts = 3,
  Duration retryDelay = const Duration(seconds: 2),
  String? operationName,
}) async {
  int attempts = 0;

  while (attempts < maxAttempts) {
    attempts++;

    // Pre-flight connectivity check
    final hasConnection = await _checkConnectivity();
    if (!hasConnection) {
      if (attempts == maxAttempts) {
        return ApiResponse.error(
          'No internet connection available. Please check your network and try again.',
          isNetworkError: true,
        );
      } else {
        // Wait before retry with exponential backoff
        await Future.delayed(Duration(seconds: retryDelay.inSeconds * attempts));
        continue;
      }
    }

    // Execute network call if connectivity is available
    final result = await networkCall();

    // Return immediately if successful or non-retryable error
    if (result.isSuccess || !DioExceptionHandler.shouldRetryError(result)) {
      return result;
    }

    // Retry with exponential backoff for retryable errors
    if (attempts < maxAttempts) {
      await Future.delayed(Duration(seconds: retryDelay.inSeconds * attempts));
    }
  }

  return ApiResponse.error('Network request failed after $maxAttempts attempts');
}
```

### Retry Logic Breakdown

#### 1. Initial Connectivity Check

- **Purpose**: Prevents unnecessary API attempts when offline
- **Implementation**: Checks actual internet access, not just network interface status
- **Benefit**: Saves battery and provides immediate feedback for offline scenarios

#### 2. Real-time Status Monitoring

```dart
@override
Stream<InternetStatus> internetStatus() {
  return InternetConnection().onStatusChange;
}
```

**Benefits:**

- **Live Updates**: App can react to connectivity changes in real-time
- **UI Feedback**: Show/hide offline indicators based on actual connectivity
- **User Experience**: Proactive communication about network state


### Integration with Other Components

#### With NetworkCallsRepositoryImpl

```dart
// NetworkCallsRepositoryImpl delegates connectivity concerns
return await _connectivityRepository.executeWithConnectivityCheck<T>(
  networkCall: () async {
    // DioRepository handles the actual HTTP request
    final response = await _dioRepository.get<T>(path);
    return ApiResponse.success(response.data);
  },
  operationName: 'GET $path',
);
```

#### With DioRepositoryImpl

- **Complementary**: Dio handles HTTP-level errors, Connectivity handles network availability
- **Coordination**: Connectivity checks prevent unnecessary HTTP attempts


#### With TokenService

- **Authentication Flow**: Ensures token refresh only attempted when online
- **Security**: Prevents token operations during unstable connections
- **State Management**: Coordinates authentication state with network state

---

## How Components Work Together

### 1. Request Initialization Flow

```
NetworkCallsRepository → ConnectivityRepositoryImpl → DioRepository → TokenService → API Call
```

1. **NetworkCallsRepository** receives API request from application layer
2. **ConnectivityRepositoryImpl** performs pre-flight connectivity check
3. **DioRepository** configures HTTP request with interceptors
4. **TokenService** automatically injects valid authentication token
5. Request executed with full security, retry logic, and error handling
6. Response standardized and returned through the chain

### 2. Authentication Flow

```
Request → TokenService.getValidToken() → Token Validation → Auto-Refresh if Needed → Bearer Token Injection
```

- Every request automatically includes Bearer token authentication
- Expired tokens trigger seamless refresh without user intervention
- Failed refresh clears tokens and redirects to login
- Token integrity validation prevents tampered token usage
- All operations are transparent to the calling code

---

### Recovery Mechanisms

#### Automatic Token Refresh

```dart
if (error.response?.statusCode == 401) {
  final refreshed = await _tokenService.refreshToken();
  if (refreshed) {
    // Retry original request with new token
    final response = await _dio.fetch(originalRequest);
    return response;
  } else {
    // Redirect to login
    await _tokenService.clearTokens();
    throw AuthenticationException();
  }
}
```

#### Smart Retry Logic

- **Network Issues**: Check connectivity before retry
- **Server Errors**: Exponential backoff (1s, 3s, 5s)
- **Rate Limiting**: Respect 429 status codes
- **Circuit Breaking**: Stop retrying after max attempts

#### Offline Mode Support

- **Detection**: Real-time connectivity monitoring
- **Queuing**: Store failed requests for later retry
- **User Feedback**: Clear offline state indication
- **Background Sync**: Automatic retry when connection restored

---

## API Response Standardization

### ApiResponse<T> Structure

```dart
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? metadata;
  final bool isNetworkError;
}
```

### Response Types

- **Success**: `ApiResponse.success(data, statusCode: 200)`
- **Client Error**: `ApiResponse.error(message, statusCode: 400)`
- **Network Error**: `ApiResponse.error(message, isNetworkError: true)`
- **Server Error**: `ApiResponse.error(message, statusCode: 500)`


---

### API Constants Configuration

```dart
class ApiConstants {
  static const String baseUrl = 'https://openlibrary.org';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int maxRetries = 3;
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 3),
    Duration(seconds: 5)
  ];
}
```

### Dependency Injection Setup

```dart
// Providers for dependency injection with proper dependency hierarchy
final tokenRepositoryProvider = Provider<TokenRepository>((ref) => TokenRepositoryImpl());

final dioRepositoryProvider = Provider<DioRepository>((ref) =>
  DioRepositoryImpl(ref.read(tokenRepositoryProvider)));

final connectivityRepositoryProvider = Provider<ConnectivityRepository>((ref) =>
  ConnectivityRepositoryImpl());

final networkCallsRepositoryProvider = Provider<NetworkCallsRepository>((ref) =>
  NetworkCallsRepositoryImplementation(
    ref.read(dioRepositoryProvider),
    ref.read(connectivityRepositoryProvider)
  ));
```

---
