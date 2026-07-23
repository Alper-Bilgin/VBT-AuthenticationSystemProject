import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

/// ===========================================================
/// App Router
/// -----------------------------------------------------------
/// Uygulamanın tüm sayfa yönlendirmelerini yönetir.
///
/// Route Listesi:
/// • /           -> Login Screen
/// • /register   -> Register Screen
///
/// Yeni ekranlar eklendikçe tüm route tanımları
/// bu dosya üzerinden yönetilecektir.
/// ===========================================================
class AppRouter {
  AppRouter._();

  /// Global GoRouter instance
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,

    /// Uygulamanın başlangıç ekranı
    initialLocation: '/',

    routes: [
      // =======================================================
      // LOGIN
      // =======================================================
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // =======================================================
      // REGISTER
      // =======================================================
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

// =======================================================
// HOME
// =======================================================
GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomeScreen(),
),

],
    // =========================================================
    // ERROR PAGE
    // =========================================================
    errorBuilder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 72,
                  color: Colors.redAccent,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Page Not Found",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Route: ${state.uri}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text("Back to Login"),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}