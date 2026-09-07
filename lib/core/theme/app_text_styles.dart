import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale. Built on the system font with tuned weight/letter
/// spacing to read as premium rather than default Material. Swap the
/// [fontFamily] here once an official Artinium typeface is supplied.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static TextStyle display(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color,
        height: 1.15,
      );

  static TextStyle h1(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );

  static TextStyle h2(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle body(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyStrong(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle caption(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle button = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    color: AppColors.background,
  );

  static TextStyle wordmark(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: 6,
        color: color,
      );

  static TextStyle tagline(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.4,
        color: color,
      );
}
