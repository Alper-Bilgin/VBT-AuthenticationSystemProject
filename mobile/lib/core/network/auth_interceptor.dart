import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';
import 'auth_api_service.dart';


class AuthInterceptor extends Interceptor {

  bool _isRefreshing = false;


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


    final statusCode =
        err.response?.statusCode;


    if (statusCode == 401 && !_isRefreshing) {

      try {

        _isRefreshing = true;


        final refreshResponse =
            await AuthApiService.refreshToken();


        final newAccessToken =
            refreshResponse.data["access_token"];


        if (newAccessToken != null &&
            newAccessToken.isNotEmpty) {


          await SecureStorageService.saveAccessToken(
            newAccessToken,
          );


          final requestOptions =
              err.requestOptions;


          requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';



          final response =
              await Dio().fetch(requestOptions);


          return handler.resolve(response);
        }


      } catch (e) {

        print(
          "Token refresh failed: $e",
        );


      } finally {

        _isRefreshing = false;
      }

    }


    handler.next(err);
  }
}