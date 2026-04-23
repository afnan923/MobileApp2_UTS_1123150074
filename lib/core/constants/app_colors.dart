import 'package:flutter/material.dart';

class AppColors {
  // 🎣 Primary
  static const Color primary = Color(0xFF1565C0);
  static const Color accent = Color(0xFF26A69A);

  // 🌊 Gradient laut
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF1976D2),
      Color(0xFF42A5F5),
      Color(0xFF80DEEA),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 🌊 Soft gradient
  static const LinearGradient oceanSoftGradient = LinearGradient(
    colors: [
      Color(0xFF1565C0),
      Color(0xFF42A5F5),
      Color(0xFFB3E5FC),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 🧊 Glass effect colors (INI YANG DIPAKAI DI WIDGET)
  static Color glass = Colors.white.withOpacity(0.15);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color glassStrong = Colors.white.withOpacity(0.25);

  // 🧾 Surface fallback
  static const Color surface = Colors.white;

  // ❌ Error
  static const Color error = Colors.red;
}