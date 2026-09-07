/// Design tokens shared across the app. Do not repeat these magic numbers
/// inline in widgets — import and reference this class instead.
class AppRadius {
  AppRadius._();
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 999;
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppSizes {
  AppSizes._();
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double buttonHeight = 56;
  static const double cardPadding = 16;
  static const double bottomNavHeight = 64;
}

class AppDurations {
  AppDurations._();
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 2200);
}
