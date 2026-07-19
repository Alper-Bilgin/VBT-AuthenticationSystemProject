import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';


/// ===========================================================
/// App Theme
/// -----------------------------------------------------------
/// Uygulamanın tüm görsel sistemini tek noktadan yönetir.
/// ===========================================================

class AppTheme {

  AppTheme._();



  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    brightness: Brightness.light,



    colorScheme: ColorScheme.light(

      primary: AppColors.primary,

      secondary: AppColors.secondary,

      surface: AppColors.surface,

      error: AppColors.error,

      outline: AppColors.border,

    ),



    scaffoldBackgroundColor: AppColors.background,





    //==========================================================
    // Typography
    //==========================================================

    textTheme: TextTheme(

      displayLarge: AppTextStyles.displayLarge,

      headlineLarge: AppTextStyles.headlineLarge,

      headlineMedium: AppTextStyles.headlineMedium,


      titleLarge: AppTextStyles.titleLarge,

      titleMedium: AppTextStyles.titleMedium,


      bodyLarge: AppTextStyles.bodyLarge,

      bodyMedium: AppTextStyles.bodyMedium,


      labelLarge: AppTextStyles.labelLarge,

      labelMedium: AppTextStyles.labelMedium,

      labelSmall: AppTextStyles.labelSmall,

    ),






    //==========================================================
    // TextField
    //==========================================================

    inputDecorationTheme: InputDecorationTheme(

      filled: true,


      fillColor: AppColors.surface,



      contentPadding: const EdgeInsets.symmetric(

        horizontal: 20,

        vertical: 16,

      ),



      hintStyle: AppTextStyles.bodyMedium,



      border: OutlineInputBorder(

        borderRadius: AppRadius.radiusMd,

        borderSide: BorderSide.none,

      ),



      enabledBorder: OutlineInputBorder(

        borderRadius: AppRadius.radiusMd,


        borderSide: BorderSide(

          color: AppColors.border,

        ),

      ),




      focusedBorder: OutlineInputBorder(

        borderRadius: AppRadius.radiusMd,


        borderSide: BorderSide(

          color: AppColors.primary,

          width: 1.5,

        ),

      ),


    ),






    //==========================================================
    // Button
    //==========================================================

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(


        backgroundColor: AppColors.primary,


        foregroundColor: Colors.white,


        elevation: 0,



        padding: const EdgeInsets.symmetric(

          horizontal: 24,

          vertical: 16,

        ),



        shape: RoundedRectangleBorder(

          borderRadius: AppRadius.radiusLg,

        ),



        textStyle: AppTextStyles.labelLarge,


      ),

    ),







    //==========================================================
    // Card
    //==========================================================

    cardTheme: CardThemeData(

      color: AppColors.surface,


      elevation: 0,


      shape: RoundedRectangleBorder(

        borderRadius: AppRadius.radiusLg,

      ),

    ),





    dividerTheme: DividerThemeData(

      color: AppColors.border,

    ),


  );

}