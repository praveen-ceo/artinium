import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../models/device.dart';

IconData deviceIcon(DeviceType type) {
  switch (type) {
    case DeviceType.light:
      return Icons.lightbulb_outline;
    case DeviceType.fan:
      return Icons.mode_fan_off_outlined;
    case DeviceType.ac:
      return Icons.ac_unit_outlined;
    case DeviceType.tv:
      return Icons.tv_outlined;
    case DeviceType.curtain:
      return Icons.curtains_closed_outlined;
    case DeviceType.airPurifier:
      return Icons.air_outlined;
  }
}

class DeviceTile extends StatelessWidget {
  final Device device;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  const DeviceTile({
    super.key,
    required this.device,
    required this.onToggle,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final offline = device.status == DeviceStatus.offline;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: offline ? null : onOpen,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: device.isOn && !offline
                  ? AppColors.gold.withOpacity(0.5)
                  : scheme.onSurface.withOpacity(0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                deviceIcon(device.type),
                color: offline
                    ? scheme.onSurface.withOpacity(0.3)
                    : (device.isOn ? AppColors.gold : scheme.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                device.name,
                style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                offline ? 'Offline' : (device.isOn ? 'ON' : 'OFF'),
                style: TextStyle(
                  color: offline
                      ? AppColors.error
                      : (device.isOn ? AppColors.success : scheme.onSurface.withOpacity(0.5)),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (!offline)
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: device.isOn,
                      activeColor: AppColors.gold,
                      onChanged: (_) => onToggle(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
