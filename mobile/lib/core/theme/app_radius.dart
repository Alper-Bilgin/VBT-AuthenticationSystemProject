import 'package:flutter/material.dart';

/// ===========================================================
/// App Radius
/// -----------------------------------------------------------
/// Uygulama genelinde kullanılan köşe yuvarlaklıkları.
/// BorderRadius.circular(...) yerine bu sabitler kullanılmalıdır.
/// ===========================================================
class AppRadius {
  AppRadius._();

  /// Küçük ikonlar, checkbox vb.
  static const double xs = 6;

  /// Küçük bileşenler
  static const double sm = 10;

  /// Input alanları
  static const double md = 16;

  /// Kartlar ve butonlar
  static const double lg = 20;

  /// Büyük kartlar
  static const double xl = 28;

  /// Hero kartlar
  static const double xxl = 36;

  // Hazır BorderRadius'lar (isteğe bağlı kullanım)

  static const BorderRadius radiusXs = BorderRadius.all(
    Radius.circular(xs),
  );

  static const BorderRadius radiusSm = BorderRadius.all(
    Radius.circular(sm),
  );

  static const BorderRadius radiusMd = BorderRadius.all(
    Radius.circular(md),
  );

  static const BorderRadius radiusLg = BorderRadius.all(
    Radius.circular(lg),
  );

  static const BorderRadius radiusXl = BorderRadius.all(
    Radius.circular(xl),
  );

  static const BorderRadius radiusXxl = BorderRadius.all(
    Radius.circular(xxl),
  );
}