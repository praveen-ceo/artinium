import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

class NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const NavTab(this.icon, this.activeIcon, this.label);
}

const List<NavTab> kNavTabs = [
  NavTab(Icons.home_outlined, Icons.home, 'Home'),
  NavTab(Icons.grid_view_outlined, Icons.grid_view, 'Rooms'),
  NavTab(Icons.graphic_eq_outlined, Icons.graphic_eq, 'Jarvis'),
  NavTab(Icons.bolt_outlined, Icons.bolt, 'Energy'),
  NavTab(Icons.person_outline, Icons.person, 'Profile'),
];

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: AppSizes.bottomNavHeight,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.onSurface.withOpacity(0.08))),
      ),
      child: Row(
        children: List.generate(kNavTabs.length, (i) {
          final tab = kNavTabs[i];
          final selected = i == currentIndex;
          final color = selected ? AppColors.gold : scheme.onSurface.withOpacity(0.5);
          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(selected ? tab.activeIcon : tab.icon, color: color, size: AppSizes.iconMd - 2),
                  const SizedBox(height: 4),
                  Text(
                    tab.label,
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
