import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';
import 'dio_client.dart';

/// ===========================================================
/// Authentication API Service
/// -----------------------------------------------------------
/// Backend Authentication işlemlerini yönetir.
/// ===========================================================
class AuthApiService {
  AuthApiService._();

  static final Dio _dio = DioClient.dio;

    static final Dio _refreshDio = Dio();

  // ===========================================================
  // Login
  // ===========================================================

  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    final data = response.data;

    await SecureStorageService.saveAccessToken(
      data["access_token"],
    );

    await SecureStorageService.saveRefreshToken(
      data["refresh_token"],
    );

    return response;
  }

  // ===========================================================
  // Register
  // ===========================================================

  static Future<Response> register({
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      ApiConstants.register,
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  // ===========================================================
// Refresh Token
// ===========================================================

static Future<Response> refreshToken() async {
  final refreshToken =
      await SecureStorageService.getRefreshToken();

  return await _refreshDio.post(
    ApiConstants.refresh,
    data: {
      "refreshToken": refreshToken,
    },
  );
}

  // ===========================================================
  // Logout
  // ===========================================================

  static Future<Response> logout() async {
    final refreshToken =
        await SecureStorageService.getRefreshToken();

    final response = await _dio.post(
      ApiConstants.logout,
      data: {
        "refreshToken": refreshToken,
      },
    );

    await SecureStorageService.clear();

    return response;
  }
}