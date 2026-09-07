import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.gold),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(message!, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          ],
        ],
      ),
    );
  }
}

/// Generic empty / error / offline placeholder with an optional retry.
class InfoStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const InfoStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  const InfoStateView.empty({super.key, required this.title, this.subtitle})
      : icon = Icons.inbox_outlined,
        actionLabel = null,
        onAction = null,
        iconColor = null;

  const InfoStateView.offline({super.key, required this.title, this.subtitle, this.actionLabel, this.onAction})
      : icon = Icons.wifi_off_outlined,
        iconColor = AppColors.warning;

  const InfoStateView.error({super.key, required this.title, this.subtitle, this.actionLabel, this.onAction})
      : icon = Icons.error_outline,
        iconColor = AppColors.error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: iconColor ?? scheme.onSurface.withOpacity(0.4)),
            const SizedBox(height: AppSpacing.md),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600, fontSize: 15)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, textAlign: TextAlign.center, style: TextStyle(color: scheme.onSurface.withOpacity(0.55), fontSize: 13)),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.gold, side: const BorderSide(color: AppColors.gold)),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
