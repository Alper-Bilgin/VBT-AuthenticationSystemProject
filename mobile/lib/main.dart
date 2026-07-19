import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';


void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'VBT Authentication System',

      theme: AppTheme.lightTheme,

      home: const Scaffold(
        body: Center(
          child: Text(
            'VBT Authentication System',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

    );
  }
}