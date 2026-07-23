import 'package:flutter/material.dart';

import '../../../../core/network/auth_api_service.dart';

class AuthController extends ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;


  Future<bool> logout() async {

    try {

      _isLoading = true;
      notifyListeners();


      await AuthApiService.logout();


      return true;


    } catch (e) {

      return false;


    } finally {

      _isLoading = false;
      notifyListeners();

    }
  }
}