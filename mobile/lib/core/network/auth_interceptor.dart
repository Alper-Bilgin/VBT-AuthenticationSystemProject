import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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



        final data = refreshResponse.data;



        final newAccessToken =
            data["access_token"];



        final newRefreshToken =
            data["refresh_token"];




        if (newAccessToken != null &&
            newAccessToken.isNotEmpty) {



          await SecureStorageService.saveAccessToken(
            newAccessToken,
          );




          if (newRefreshToken != null &&
              newRefreshToken.isNotEmpty) {


            await SecureStorageService.saveRefreshToken(
              newRefreshToken,
            );

          }




          final requestOptions =
              err.requestOptions;



          requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';




          final response =
              await Dio().fetch(requestOptions);



          return handler.resolve(response);

        }



      } catch (e) {


        debugPrint(
          "Token refresh failed: $e",
        );



        await SecureStorageService.clear();


      } finally {

        _isRefreshing = false;

      }

    }



    handler.next(err);

  }

}