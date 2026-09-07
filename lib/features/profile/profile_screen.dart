import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/repositories/user_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _items = [
    (Icons.person_outline, 'Personal Information'),
    (Icons.palette_outlined, 'App Appearance'),
    (Icons.color_lens_outlined, 'Theme Customization'),
    (Icons.notifications_none, 'Notification Settings'),
    (Icons.graphic_eq, 'Voice & AI Settings'),
    (Icons.bolt_outlined, 'Power Target & Usage'),
    (Icons.devices_other_outlined, 'Connected Devices'),
    (Icons.auto_awesome_outlined, 'Automations'),
    (Icons.home_work_outlined, 'Home Management'),
    (Icons.help_outline, 'Help & Support'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = context.watch<UserRepository>().user;
    final themeCtrl = context.watch<ThemeController>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
        children: [
          Text('Profile & Settings', style: AppTextStyles.h1(scheme.onSurface)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.gold.withOpacity(0.2),
                child: Text(user.name.isNotEmpty ? user.name[0] : '?', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 22)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTextStyles.h2(scheme.onSurface)),
                    Text(user.email, style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.55))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurface.withOpacity(0.4)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                for (final item in _items)
                  _SettingsRow(
                    icon: item.$1,
                    label: item.$2,
                    trailing: item.$2 == 'App Appearance'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(themeCtrl.isDark ? 'Dark Mode' : 'Light Mode', style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5))),
                              const SizedBox(width: 6),
                              Icon(themeCtrl.isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.gold, size: 18),
                            ],
                          )
                        : Icon(Icons.chevron_right, color: scheme.onSurface.withOpacity(0.35), size: 18),
                    onTap: () {
                      if (item.$2 == 'App Appearance') {
                        Navigator.of(context).pushNamed(AppRoutes.settings);
                      }
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsRow(
            icon: Icons.logout,
            label: 'Logout',
            labelColor: AppColors.error,
            trailing: null,
            onTap: () {
              context.read<UserRepository>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color? labelColor;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: labelColor ?? scheme.onSurface.withOpacity(0.65)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: TextStyle(color: labelColor ?? scheme.onSurface, fontSize: 14))),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
