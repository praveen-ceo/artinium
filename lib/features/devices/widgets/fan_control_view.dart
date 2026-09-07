import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/repositories/device_repository.dart';
import '../../../models/device.dart';
import 'circular_dial.dart';
import 'timer_sheet.dart';

class FanControlView extends StatelessWidget {
  final Device device;
  final DeviceRepository repo;
  const FanControlView({super.key, required this.device, required this.repo});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        // Ceiling fan visual — rotates while ON.
        _FanVisual(spinning: device.isOn),
        const SizedBox(height: AppSpacing.xl),
        Text('Status', style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5))),
        Text(
          device.isOn ? 'ON' : 'OFF',
          style: TextStyle(color: device.isOn ? AppColors.success : scheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.xl),
        CircularDial(
          value: device.fanSpeed,
          min: 1,
          max: 5,
          label: device.fanSpeedLabel,
          onIncrement: () => repo.setFanSpeed(device.id, device.fanSpeed + 1),
          onDecrement: () => repo.setFanSpeed(device.id, device.fanSpeed - 1),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomAction(
              label: 'ON',
              icon: Icons.power_settings_new,
              active: device.isOn,
              color: AppColors.success,
              onTap: () => repo.setOn(device.id, true),
            ),
            _BottomAction(
              label: 'OFF',
              icon: Icons.power_off_outlined,
              active: !device.isOn,
              color: AppColors.error,
              onTap: () => repo.setOn(device.id, false),
            ),
            _BottomAction(
              label: 'TIMER',
              icon: Icons.timer_outlined,
              active: device.timerMinutes != null && device.timerMinutes! > 0,
              color: AppColors.ai,
              onTap: () async {
                final minutes = await showTimerSheet(context, current: device.timerMinutes);
                if (minutes != null) {
                  repo.setAttribute(device.id, 'timerMinutes', minutes == 0 ? null : minutes);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _FanVisual extends StatefulWidget {
  final bool spinning;
  const _FanVisual({required this.spinning});

  @override
  State<_FanVisual> createState() => _FanVisualState();
}

class _FanVisualState extends State<_FanVisual> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    if (!widget.spinning) _controller.stop();
  }

  @override
  void didUpdateWidget(covariant _FanVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spinning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.spinning) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(Icons.mode_fan_off_outlined, size: 140, color: AppColors.gold.withOpacity(0.85)),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _BottomAction({
    required this.label,
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: active ? color.withOpacity(0.18) : scheme.surface,
            child: Icon(icon, color: active ? color : scheme.onSurface.withOpacity(0.5)),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: active ? color : scheme.onSurface.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
