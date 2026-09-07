import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/repositories/device_repository.dart';
import '../../../models/device.dart';
import 'circular_dial.dart';
import 'timer_sheet.dart';

class AcControlView extends StatelessWidget {
  final Device device;
  final DeviceRepository repo;
  const AcControlView({super.key, required this.device, required this.repo});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Icon(Icons.ac_unit, size: 100, color: device.isOn ? AppColors.ai : scheme.onSurface.withOpacity(0.2)),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          value: device.isOn,
          activeColor: AppColors.gold,
          title: Text('Power', style: AppTextStyles.bodyStrong(scheme.onSurface)),
          subtitle: Text(device.isOn ? 'ON' : 'OFF', style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5))),
          onChanged: (v) => repo.setOn(device.id, v),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: AppConstants.comfortLevels.map((level) {
              final selected = device.acMode == level;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: device.isOn ? () => repo.setAttribute(device.id, 'mode', level) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.gold.withOpacity(0.15) : scheme.surface,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.08)),
                      ),
                      alignment: Alignment.center,
                      child: Text(level, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.6))),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CircularDial(
          value: device.fanSpeed,
          min: 1,
          max: 5,
          label: 'Fan Speed',
          onIncrement: () => repo.setFanSpeed(device.id, device.fanSpeed + 1),
          onDecrement: () => repo.setFanSpeed(device.id, device.fanSpeed - 1),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton.icon(
          onPressed: () async {
            final minutes = await showTimerSheet(context, current: device.timerMinutes);
            if (minutes != null) {
              repo.setAttribute(device.id, 'timerMinutes', minutes == 0 ? null : minutes);
            }
          },
          icon: const Icon(Icons.timer_outlined, color: AppColors.ai),
          label: Text(
            device.timerMinutes != null && device.timerMinutes! > 0 ? 'Timer: ${device.timerMinutes} min' : 'Set Timer',
            style: const TextStyle(color: AppColors.ai),
          ),
        ),
      ],
    );
  }
}
