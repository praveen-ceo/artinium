import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

/// Shows a usable timer-duration picker; returns the chosen minutes
/// (or null if dismissed / "Off" selected clears the timer).
Future<int?> showTimerSheet(BuildContext context, {int? current}) {
  const options = [15, 30, 60, 120, 240];
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Set Timer', style: TextStyle(color: scheme.onSurface, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.md),
              ...options.map((minutes) => ListTile(
                    title: Text(
                      minutes < 60 ? '$minutes minutes' : '${minutes ~/ 60} hour${minutes >= 120 ? 's' : ''}',
                      style: TextStyle(color: scheme.onSurface),
                    ),
                    trailing: current == minutes ? const Icon(Icons.check, color: AppColors.gold) : null,
                    onTap: () => Navigator.pop(ctx, minutes),
                  )),
              ListTile(
                title: const Text('Off', style: TextStyle(color: AppColors.error)),
                onTap: () => Navigator.pop(ctx, 0),
              ),
            ],
          ),
        ),
      );
    },
  );
}
