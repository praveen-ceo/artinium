import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/repositories/device_repository.dart';
import 'data/repositories/energy_repository.dart';
import 'data/repositories/room_repository.dart';
import 'data/repositories/user_repository.dart';

void main() {
  runApp(const ArtiniumApp());
}

class ArtiniumApp extends StatelessWidget {
  const ArtiniumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => UserRepository()),
        ChangeNotifierProvider(create: (_) => DeviceRepository()),
        Provider(create: (_) => RoomRepository()),
        Provider(create: (_) => EnergyRepository()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeCtrl, _) {
          return MaterialApp(
            title: 'ARTINIUM',
            debugShowCheckedModeBanner: false,
            themeMode: themeCtrl.mode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
