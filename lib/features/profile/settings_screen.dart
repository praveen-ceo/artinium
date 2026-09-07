import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final themeCtrl = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('App Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Theme', style: AppTextStyles.h2(scheme.onSurface)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  label: 'Light Mode',
                  icon: Icons.light_mode_outlined,
                  selected: !themeCtrl.isDark,
                  onTap: () => themeCtrl.setDark(false),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ThemeOption(
                  label: 'Dark Mode',
                  icon: Icons.dark_mode_outlined,
                  selected: themeCtrl.isDark,
                  onTap: () => themeCtrl.setDark(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold.withOpacity(0.15) : scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.6)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
