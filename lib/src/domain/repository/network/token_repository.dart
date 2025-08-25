abstract class TokenRepository {
  Future<void> storeTokens({required String accessToken, required String refreshToken, required int expiresIn});
  Future<String?> getAccessToken();
  Future<String?> getValidToken();
  Future<String?> getRefreshToken();
  Future<bool> refreshToken();
  Future<bool> isTokenExpired();
  Future<bool> isAuthenticated();
  Future<void> clearTokens();
}
