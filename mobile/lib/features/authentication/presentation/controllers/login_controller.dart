import 'package:flutter/material.dart';

/// ===========================================================
/// Login Controller
/// -----------------------------------------------------------
/// Login ekranının iş mantığını yönetir.
///
/// Sorumlulukları:
/// • Login işlemini başlatmak
/// • Loading durumunu yönetmek
/// • Hata mesajını yönetmek
///
/// Form doğrulamaları LoginScreen içerisindeki
/// TextFormField validator'larında yapılmaktadır.
///
/// Backend entegrasyonu daha sonra
/// AuthRepository + Dio ile eklenecektir.
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

      // AuthRepository.login() burada çağrılacak.
      //
      // await authRepository.login(
      //   email: emailController.text.trim(),
      //   password: passwordController.text,
      // );

      await Future.delayed(
        const Duration(seconds: 1),
      );

      return true;
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