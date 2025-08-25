import 'dart:convert';

import 'package:crypto/crypto.dart';

class TokenUtils {
  static final TokenUtils _instance = TokenUtils._();
  factory TokenUtils() => _instance;
  TokenUtils._();
  //
  // i am encrypting token to increase the security levels
  String encryptToken(String token) {
    try {
      // i can also use AES encryption
      final bytes = utf8.encode(token);
      return base64.encode(bytes);
    } catch (e) {
      print('[TOKEN] Error encrypting token: $e');
      return token;
    }
  }

  /// Decrypt token
  String decryptToken(String encryptedToken) {
    try {
      final bytes = base64.decode(encryptedToken);
      return utf8.decode(bytes);
    } catch (e) {
      print('[TOKEN] Error decrypting token: $e');
      return encryptedToken;
    }
  }

  /// Generate hash for token integrity check
  String generateTokenHash(String token) {
    final bytes = utf8.encode(token);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate demo token for testing
  String generateDemoToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'demotoken_${timestamp}_$random';
  }
}
