import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ===========================================================
/// Secure Storage Service
/// -----------------------------------------------------------
/// Access Token ve Refresh Token güvenli şekilde saklanır.
/// ===========================================================
class SecureStorageService {
  SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ===========================================================
  // Keys
  // ===========================================================

  static const String accessTokenKey = "access_token";

  static const String refreshTokenKey = "refresh_token";

  // ===========================================================
  // Save Tokens
  // ===========================================================

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: accessTokenKey,
      value: token,
    );
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: refreshTokenKey,
      value: token,
    );
  }

  // ===========================================================
  // Read Tokens
  // ===========================================================

  static Future<String?> getAccessToken() async {
    return await _storage.read(
      key: accessTokenKey,
    );
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: refreshTokenKey,
    );
  }

  // ===========================================================
  // Delete Tokens
  // ===========================================================

  static Future<void> deleteAccessToken() async {
    await _storage.delete(
      key: accessTokenKey,
    );
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(
      key: refreshTokenKey,
    );
  }

  // ===========================================================
  // Clear Storage
  // ===========================================================

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

}