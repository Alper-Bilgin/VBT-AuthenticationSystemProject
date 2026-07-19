import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppRouter {

  AppRouter._();


  static final GoRouter router = GoRouter(

    // Uygulamanın başlangıç rotası
    initialLocation: '/',


    routes: [

      GoRoute(
        path: '/',
        name: 'splash',

        builder: (context, state) {

          return const Scaffold(

            body: Center(

              child: Text(
                'VBT Authentication System',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),

          );

        },
      ),

    ],


    // Hatalı route gelirse gösterilecek ekran
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