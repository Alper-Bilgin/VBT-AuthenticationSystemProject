import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ===========================================================
/// App Shadows
/// -----------------------------------------------------------
/// Uygulama genelinde kullanılan gölgeler.
/// Tek tip tasarım dili oluşturmak için kullanılır.
/// ===========================================================
class AppShadows {
  AppShadows._();

  /// Hafif gölge
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Kart gölgesi
  static const List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// Büyük kart / Dialog
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 28,
      offset: Offset(0, 10),
    ),
  ];

  /// Floating buton
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x254F46E5),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  /// Login Card
  static const List<BoxShadow> card = md;
}