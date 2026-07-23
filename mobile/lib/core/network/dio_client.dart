import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

import 'auth_interceptor.dart';

// ===========================================================
// Dio Client
// -----------------------------------------------------------
// Uygulamanın tüm HTTP istekleri bu client üzerinden yapılır.
// ===========================================================
class DioClient {
  DioClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(AuthInterceptor());
}