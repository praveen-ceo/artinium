import 'package:flutter/material.dart';

/// Centralized Artinium color tokens. Never hardcode hex values in screens —
/// reference these instead so the theme stays consistent and swappable.
class AppColors {
  AppColors._();

  // Brand
  static const Color gold = Color(0xFFE8A93A);
  static const Color goldLight = Color(0xFFF4C466);
  static const Color goldDark = Color(0xFFB8801F);

  // Dark theme surfaces
  static const Color background = Color(0xFF0A0E14);
  static const Color surface = Color(0xFF141922);
  static const Color surfaceElevated = Color(0xFF1B222D);
  static const Color border = Color(0xFF2A3341);

  // Light theme surfaces
  static const Color backgroundLight = Color(0xFFF7F7F9);
  static const Color surfaceLightColor = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFF0F1F4);
  static const Color borderLight = Color(0xFFE1E3E8);

  // Text
  static const Color textPrimary = Color(0xFFF5F6F8);
  static const Color textPrimaryLight = Color(0xFF14181F);
  static const Color textSecondary = Color(0xFF8B93A1);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // Semantic
  static const Color success = Color(0xFF3DD68C);
  static const Color warning = Color(0xFFF2B84B);
  static const Color error = Color(0xFFE5484D);
  static const Color ai = Color(0xFF3FC7F4);
  static const Color aiDeep = Color(0xFF1E88C4);
}
