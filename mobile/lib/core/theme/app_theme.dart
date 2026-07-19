import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';


class AppTheme {

  AppTheme._();


  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,


    scaffoldBackgroundColor: AppColors.background,


    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),


    fontFamily: "Inter",


    textTheme: const TextTheme(

      headlineLarge:
          AppTextStyles.headlineLarge,

      headlineMedium:
          AppTextStyles.headlineMedium,

      titleLarge:
          AppTextStyles.titleLarge,

      titleMedium:
          AppTextStyles.titleMedium,

      bodyLarge:
          AppTextStyles.bodyLarge,

      bodyMedium:
          AppTextStyles.bodyMedium,

      labelSmall:
          AppTextStyles.label,

    ),


    appBarTheme: const AppBarTheme(

      backgroundColor: AppColors.primary,

      foregroundColor: Colors.white,

      elevation: 0,

      centerTitle: true,

    ),


    cardTheme: CardThemeData(

      color: AppColors.surface,

      elevation: 2,

      margin: EdgeInsets.zero,

    ),


    inputDecorationTheme: InputDecorationTheme(

      filled: true,

      fillColor: AppColors.surface,


      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(12),

        borderSide:
            BorderSide(
              color: AppColors.border,
            ),

      ),

      enabledBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(12),

        borderSide:
            BorderSide(
              color: AppColors.border,
            ),

      ),

    ),


    elevatedButtonTheme:
        ElevatedButtonThemeData(

      style:
          ElevatedButton.styleFrom(

        backgroundColor:
            AppColors.primary,

        foregroundColor:
            Colors.white,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(12),

        ),

      ),

    ),

  );

}