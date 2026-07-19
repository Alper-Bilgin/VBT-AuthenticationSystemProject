import 'package:flutter/material.dart';

/// ===========================================================
/// App Colors
/// -----------------------------------------------------------
/// Uygulama genelinde kullanılan tüm renkler burada tutulur.
/// Tasarım bütünlüğünü korumak için doğrudan Color(...) yerine
/// bu sınıftaki sabitler kullanılmalıdır.
/// ===========================================================
class AppColors {
  AppColors._();

  //============================================================
  // BRAND COLORS (Derin Koyu Lacivert Tonları)
  //============================================================

  /// Ana marka rengi - İstediğin o derin, güçlü koyu lacivert tonu
  static const Color primary = Color(0xFF0A1931);

  /// Hover / Pressed - Lacivertin biraz daha koyu/gece mavisi hali
  static const Color primaryDark = Color(0xFF000C24);

  /// Hafif ton - Üst arka plandaki organik sıvı lekelerine kontrast katacak orta gece mavisi
  static const Color primaryLight = Color(0xFF15305B);

  /// İkincil vurgu rengi - Tasarımdaki beyaz alanlarda parlayacak şık bir lacivert/mavi tonu
  static const Color secondary = Color(0xFF0052CC);

  /// Açık ikincil ton
  static const Color secondaryLight = Color(0xFFE6F0FF);

  //============================================================
  // BACKGROUND
  //============================================================

  /// Uygulama arka planı (Alt kısım tamamen beyaz)
  static const Color background = Colors.white;

  /// Kart, Dialog vb.
  static const Color surface = Colors.white;

  /// Kart rengi
  static const Color card = Colors.white;

  //============================================================
  // TEXT
  //============================================================

  /// Ana yazı (Giriş alanlarının içindeki yazılar için)
  static const Color textPrimary = Color(0xFF1E293B);

  /// Açıklama yazıları ve çizgilerdeki "or" yazısı
  static const Color textSecondary = Color(0xFF8C8C8C);

  /// Placeholder vb. (İnput alanlarının içindeki ipucu yazıları)
  static const Color textHint = Color(0xFFB3B3B3);

  /// Beyaz yazı (Mavi/Lacivert arka plan üzerindeki başlıklar ve buton yazısı için)
  static const Color textOnPrimary = Colors.white;

  //============================================================
  // BORDER & DIVIDER (Minimalist İnce Çizgiler)
  //============================================================

  /// İnput alanlarının altındaki ince çizgiler ve "or" çizgisi için
  static const Color border = Color(0xFFE2E8F0);

  static const Color divider = Color(0xFFE2E8F0);

  //============================================================
  // ICON
  //============================================================

  /// Giriş alanlarının solundaki minimalist gri ikonlar için
  static const Color iconPrimary = Color(0xFF8C8C8C);

  static const Color iconSecondary = Color(0xFFB3B3B3);

  //============================================================
  // STATUS COLORS
  //============================================================

  static const Color success = Color(0xFF22C55E);

  static const Color warning = Color(0xFFF59E0B);

  static const Color error = Color(0xFFEF4444);

  static const Color info = Color(0xFF0052CC);

  //============================================================
  // DISABLED
  //============================================================

  static const Color disabled = Color(0xFFCBD5E1);

  //============================================================
  // SHADOW
  //============================================================

  static const Color shadow = Color(0x0A000000);

  //============================================================
  // OVERLAY
  //============================================================

  static const Color overlay = Color(0x66000000);
}