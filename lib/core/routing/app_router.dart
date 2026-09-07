import 'package:flutter/material.dart';
import '../../features/authentication/login_screen.dart';
import '../../features/devices/device_control_screen.dart';
import '../../features/energy/energy_screen.dart';
import '../../features/home/main_shell.dart';
import '../../features/onboarding/personalization_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/rooms/room_hub_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const personalization = '/personalization';
  static const main = '/main';
  static const roomHub = '/room';
  static const deviceControl = '/device';
  static const energyDetail = '/energy-detail';
  static const settings = '/settings';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen());
      case AppRoutes.login:
        return _page(const LoginScreen());
      case AppRoutes.personalization:
        return _page(const PersonalizationScreen());
      case AppRoutes.main:
        return _page(const MainShell());
      case AppRoutes.roomHub:
        final roomId = settings.arguments as String;
        return _page(RoomHubScreen(roomId: roomId));
      case AppRoutes.deviceControl:
        final deviceId = settings.arguments as String;
        return _page(DeviceControlScreen(deviceId: deviceId));
      case AppRoutes.energyDetail:
        return _page(const EnergyScreen(detailed: true));
      case AppRoutes.settings:
        return _page(const SettingsScreen());
      default:
        return _page(const SplashScreen());
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
