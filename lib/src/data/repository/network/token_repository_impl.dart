import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mood_tracker_assessment/constants/api_constants.dart';
import 'package:mood_tracker_assessment/src/domain/repository/network/token_repository.dart';
import 'package:mood_tracker_assessment/utils/token_utils.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  return TokenRepositoryImpl();
});

class TokenRepositoryImpl extends TokenRepository {
  final TokenUtils tokenUtils = TokenUtils();

  // i am using flutter secure storage because it encourages best practices for storing sensitive information
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

  //
  static const String _accessTokenKey = '${ApiConstants.tokenKey}_encrypted';
  static const String _refreshTokenKey = '${ApiConstants.refreshTokenKey}_encrypted';
  static const String _tokenExpiryKey = ApiConstants.tokenExpiryKey;
  static const String _tokenHashKey = 'token_hash';

  //! Store tokens securely
  @override
  Future<void> storeTokens({required String accessToken, required String refreshToken, required int expiresIn}) async {
    try {
      final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
      final tokenHash = tokenUtils.generateTokenHash(accessToken);

      // Encrypt tokens before storing
      final encryptedAccessToken = tokenUtils.encryptToken(accessToken);
      final encryptedRefreshToken = tokenUtils.encryptToken(refreshToken);

      await Future.wait([
        _secureStorage.write(key: _accessTokenKey, value: encryptedAccessToken),
        _secureStorage.write(key: _refreshTokenKey, value: encryptedRefreshToken),
        _secureStorage.write(key: _tokenExpiryKey, value: expiryTime.toIso8601String()),
        _secureStorage.write(key: _tokenHashKey, value: tokenHash),
      ]);

      print('[TOKEN] Tokens stored securely with expiry: $expiryTime');
    } catch (e) {
      print('[TOKEN] Error storing tokens: $e');
      throw Exception('Failed to store authentication tokens');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final encryptedToken = await _secureStorage.read(key: _accessTokenKey);
      if (encryptedToken == null) return null;

      final token = tokenUtils.decryptToken(encryptedToken);

      // Validate token integrity
      final storedHash = await _secureStorage.read(key: _tokenHashKey);
      final currentHash = tokenUtils.generateTokenHash(token);

      if (storedHash != currentHash) {
        print('[TOKEN] Token integrity check failed');
        // since both tokens are not equal, we clear the stored tokens
        await clearTokens();
        return null;
      }

      return token;
    } catch (e) {
      print('[TOKEN] Error retrieving access token: $e');
      await clearTokens();
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final encryptedToken = await _secureStorage.read(key: _refreshTokenKey);
      if (encryptedToken == null) return null;

      return tokenUtils.decryptToken(encryptedToken);
    } catch (e) {
      print('[TOKEN] Error retrieving refresh token: $e');
      return null;
    }
  }

  @override
  Future<bool> isTokenExpired() async {
    try {
      final expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryStr == null) return true;

      final expiry = DateTime.parse(expiryStr);
      final now = DateTime.now();

      // This is me simulating the token expiration, ideally the token should be validated with the server(Backend)
      return now.isAfter(expiry.subtract(const Duration(minutes: 5)));
    } catch (e) {
      print('[TOKEN] Error checking token expiry: $e');
      return true;
    }
  }

  @override
  Future<bool> isAuthenticated() {
    // TODO: implement isAuthenticated
    throw UnimplementedError();
  }

  @override
  Future<void> clearTokens() {
    // TODO: implement clearTokens
    throw UnimplementedError();
  }

  @override
  Future<String?> getValidToken() async {
    try {
      final token = await getAccessToken();
      if (token == null) return null;

      final isExpired = await isTokenExpired();
      if (!isExpired) {
        return token;
      }

      // Try to refresh the token
      print('[TOKEN] Token expired, attempting refresh...');
      final refreshSuccess = await refreshToken();

      if (refreshSuccess) {
        return await getAccessToken();
      } else {
        await clearTokens();
        return null;
      }
    } catch (e) {
      print('[TOKEN] Error getting valid token: $e');
      await clearTokens();
      return null;
    }
  }

  @override
  Future<bool> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
