import 'package:flutter/material.dart';

/// ===========================================================
/// Login Controller
/// -----------------------------------------------------------
/// Login ekranındaki iş mantığını yönetir.
/// UI sadece kullanıcı etkileşimlerini bu sınıfa iletir.
///
/// Backend bağlantısı daha sonra repository/service üzerinden
/// buraya bağlanacaktır.
/// ===========================================================
class LoginController extends ChangeNotifier {
  // Giriş Alanı Kontrolcüleri (Name eklendi)
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Kullanıcı kayıt/giriş işlemi
  Future<bool> login() async {
    _removeError();

    if (!_validateForm()) {
      return false;
    }

    try {
      _setLoading(true);

      // TODO:
      // Buraya ileride AuthRepository bağlanacak.
      //
      // Örnek:
      //
      // await authRepository.register(
      //    name: nameController.text.trim(),
      //    email: emailController.text.trim(),
      //    password: passwordController.text.trim(),
      // );

      await Future.delayed(
        const Duration(seconds: 1),
      );

      return true;
    } catch (e) {
      _errorMessage = "An error occurred. Please try again.";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Form elemanlarının doğruluğunu kontrol eden fonksiyon
  bool _validateForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 1. Name Doğrulaması (Yeni Eklendi)
    if (name.isEmpty) {
      _errorMessage = "Name is required";
      notifyListeners();
      return false;
    }

    // 2. Email Doğrulaması
    if (email.isEmpty) {
      _errorMessage = "Email is required";
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = "Please enter a valid email";
      notifyListeners();
      return false;
    }

    // 3. Password Doğrulaması
    if (password.isEmpty) {
      _errorMessage = "Password is required";
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = "Password must be at least 6 characters";
      notifyListeners();
      return false;
    }

    return true;
  }

  /// RegEx ile email format kontrolü
  bool _isValidEmail(String email) {
    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return regex.hasMatch(email);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _removeError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Bellek sızıntısını önlemek için nameController dispose edildi
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}