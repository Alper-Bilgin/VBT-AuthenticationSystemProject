import 'package:flutter/material.dart';

/// ===========================================================
/// Register Controller
/// -----------------------------------------------------------
/// Register ekranının form yönetimini sağlar.
/// Şimdilik backend bağlantısı içermez.
/// Daha sonra Dio + Repository ile entegre edilecektir.
/// ===========================================================
class RegisterController {
  // ===========================================================
  // Controllers
  // ===========================================================

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // ===========================================================
  // States
  // ===========================================================

  bool isLoading = false;

  String? errorMessage;

  // ===========================================================
  // Register
  // ===========================================================

  Future<bool> register() async {
    isLoading = true;
    errorMessage = null;

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;

    return true;
  }

  // ===========================================================
  // Validators
  // ===========================================================

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "First name is required";
    }

    if (value.trim().length < 2) {
      return "Minimum 2 characters";
    }

    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Last name is required";
    }

    if (value.trim().length < 2) {
      return "Minimum 2 characters";
    }

    return null;
  }

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

    if (value.length < 6) {
      return "Minimum 6 characters";
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
  // Dispose
  // ===========================================================

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}