/// ===========================================================
/// API Constants
/// -----------------------------------------------------------
/// Uygulamanın backend adresleri burada tutulur.
/// ===========================================================
class ApiConstants {
  ApiConstants._();

  /// Android Emulator
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  /// Authentication Endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refresh = "/auth/refresh";
  static const String logout = "/auth/logout";

  /// Request timeout
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}