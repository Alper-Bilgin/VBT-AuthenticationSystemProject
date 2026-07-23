import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';
import 'auth_api_service.dart';


class AuthInterceptor extends Interceptor {

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {

    final accessToken =
        await SecureStorageService.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {

      options.headers['Authorization'] =
          'Bearer $accessToken';
    }

    handler.next(options);
  }



  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {


    if (err.response?.statusCode == 401) {

      try {

        final refreshResponse =
            await AuthApiService.refreshToken();


        final newAccessToken =
            refreshResponse.data["access_token"];


        if (newAccessToken != null) {

          print(
            "Token refresh successful",
          );

        }


      } catch (e) {

        print(
          "Token refresh failed: $e",
        );

      }

    }


    handler.next(err);
  }
}