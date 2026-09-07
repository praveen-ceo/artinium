import 'package:flutter/material.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../ai/ai_screen.dart';
import '../energy/energy_screen.dart';
import '../profile/profile_screen.dart';
import '../rooms/rooms_list_screen.dart';
import 'my_home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _tabs = [
    MyHomeScreen(),
    RoomsListScreen(),
    AiScreen(),
    EnergyScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _tabs),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNav(currentIndex: _index, onTap: (i) => setState(() => _index = i)),
      ),
    );
  }
}
