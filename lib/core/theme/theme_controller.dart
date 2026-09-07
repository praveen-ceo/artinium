import 'package:flutter/material.dart';

/// App-wide theme mode state. Defaults to dark per spec. Injected via
/// Provider at the app root; Settings screen calls [toggle] / [setDark].
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void setDark(bool dark) {
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggle() => setDark(!isDark);
}
