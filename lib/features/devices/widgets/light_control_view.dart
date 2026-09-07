import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/repositories/device_repository.dart';
import '../../../models/device.dart';

class LightControlView extends StatelessWidget {
  final Device device;
  final DeviceRepository repo;
  const LightControlView({super.key, required this.device, required this.repo});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Icon(
          Icons.lightbulb,
          size: 120,
          color: device.isOn ? AppColors.gold.withOpacity(device.brightness / 100 * 0.7 + 0.3) : scheme.onSurface.withOpacity(0.2),
        ),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          value: device.isOn,
          activeColor: AppColors.gold,
          title: Text('Power', style: AppTextStyles.bodyStrong(scheme.onSurface)),
          subtitle: Text(device.isOn ? 'ON' : 'OFF', style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5))),
          onChanged: (v) => repo.setOn(device.id, v),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brightness', style: AppTextStyles.body(scheme.onSurface.withOpacity(0.7))),
              Slider(
                value: device.brightness.toDouble(),
                min: 0,
                max: 100,
                activeColor: AppColors.gold,
                inactiveColor: scheme.onSurface.withOpacity(0.1),
                label: '${device.brightness}%',
                onChanged: device.isOn ? (v) => repo.setAttribute(device.id, 'brightness', v.round()) : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: ['Warm', 'Bright', 'Cool'].map((tone) {
              final selected = device.ambience == tone;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(tone),
                    selected: selected,
                    selectedColor: AppColors.gold.withOpacity(0.2),
                    labelStyle: TextStyle(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.7)),
                    side: BorderSide(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.1)),
                    onSelected: (_) => repo.setAttribute(device.id, 'ambience', tone),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
