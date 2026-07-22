import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/auth_api_service.dart';

/// ===========================================================
/// Register Controller
/// -----------------------------------------------------------
/// Register ekranının iş mantığını yönetir.
///
/// Sorumlulukları:
/// • Register işlemini başlatmak
/// • Loading durumunu yönetmek
/// • Backend hata mesajlarını göstermek
///
/// Form doğrulamaları bu controller içerisinde yapılmaktadır.
/// ===========================================================
class RegisterController extends ChangeNotifier {
  // ===========================================================
  // Controllers
  // ===========================================================

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // ===========================================================
  // States
  // ===========================================================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ===========================================================
  // Register
  // ===========================================================

  Future<bool> register() async {
    _clearError();

    try {
      _setLoading(true);

      await AuthApiService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

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
      return "Invalid email address";
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
      r'^(?=.*[A-Z])(?=.*\d).{8,64}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return "Must contain at least one uppercase letter and one number";
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }

    if (value != passwordController.text) {
      return "Passwords do not match";
    }

    return null;
  }

  // ===========================================================
  // Helpers
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
    confirmPasswordController.dispose();

    super.dispose();
  }
}