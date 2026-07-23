import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';

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
}