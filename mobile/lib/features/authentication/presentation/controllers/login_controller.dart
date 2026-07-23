import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/auth_api_service.dart';
import '../../../../core/storage/secure_storage_service.dart';

/// ===========================================================
/// Login Controller
/// -----------------------------------------------------------
/// Login ekranının iş mantığını yönetir.
/// ===========================================================
class LoginController extends ChangeNotifier {
  // ===========================================================
  // Controllers
  // ===========================================================

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // ===========================================================
  // States
  // ===========================================================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ===========================================================
  // Login
  // ===========================================================

  Future<bool> login() async {
    _clearError();

    try {
      _setLoading(true);

      await AuthApiService.login(
  email: emailController.text.trim(),
  password: passwordController.text,
);

// Temporary debug
await SecureStorageService.debugPrintTokens();

return true;
    } on DioException catch (e) {
      String message = "An unexpected error occurred.";

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;

        if (data["detail"] != null) {
          message = data["detail"];
        } else if (data["message"] != null) {
          message = data["message"];
        }
      }

      _setError(message);

      return false;
    } catch (_) {
      _setError(
        "An unexpected error occurred. Please try again.",
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================
  // Validators
  // ===========================================================

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid email";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (value.length > 64) {
      return "Password must be at most 64 characters";
    }

    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d).+$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return "Password must contain at least one uppercase letter and one number";
    }

    return null;
  }

  // ===========================================================
  // State Helpers
  // ===========================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ===========================================================
  // Dispose
  // ===========================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}