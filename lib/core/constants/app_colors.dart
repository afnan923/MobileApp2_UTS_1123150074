import 'package:flutter/material.dart';

class AppColors {

  // ── Brand ─────────────────────────────
  static const Color primary      = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color primaryDark  = Color(0xFF0D47A1);
  static const Color accent       = Color(0xFF2563EB);

  // ── Light Mode ────────────────────────
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface    = Colors.white;
  static const Color textPrimary     = Color(0xFF212121);
  static const Color textSecondary   = Color(0xFF757575);
  static const Color textHint        = Color(0xFFBDBDBD);
  static const Color outline         = Color(0xFFE0E0E0);

  // ── Dark Mode ─────────────────────────
  static const Color darkBackground  = Color(0xFF121212);
  static const Color darkSurface     = Color(0xFF1E1E1E);
  static const Color darkSurfaceCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary   = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkTextHint      = Color(0xFF666666);
  static const Color darkOutline       = Color(0xFF3A3A3A);

  // ── Gradient ──────────────────────────
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

  static const LinearGradient oceanGradientDark = LinearGradient(
    colors: [
      Color(0xFF020617),
      Color(0xFF0B1F3A),
      Color(0xFF0F3057),
      Color(0xFF1B4965),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Glass ─────────────────────────────
  static const Color glass       = Color(0x26FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassStrong = Color(0x40FFFFFF);

  // ── System ────────────────────────────
  static const Color error = Color(0xFFD32F2F);
}
