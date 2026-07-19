import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';

/// Uygulamanın tüm yönlendirmelerini yönetir.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    // Açılış ekranı
    initialLocation: '/',

    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],

    // Tanımlanmamış bir route açılırsa gösterilir.
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Page not found: ${state.uri}',
          ),
        ),
      );
    },
  );
}