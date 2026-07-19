import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTextStyles {

  AppTextStyles._();


  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );


  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );


  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );


  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );


  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );


  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );


  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

}