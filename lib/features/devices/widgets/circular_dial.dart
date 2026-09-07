import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Circular progress dial with a big centered value, +/- controls beside
/// it. Shared by fan speed and AC fan-speed so the control feel is
/// consistent across device types.
class CircularDial extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final String label;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CircularDial({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = (value - min) / (max - min == 0 ? 1 : (max - min));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _RoundIconButton(icon: Icons.remove, onTap: value > min ? onDecrement : null),
        const SizedBox(width: 24),
        SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: scheme.onSurface.withOpacity(0.08),
                  valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Speed', style: TextStyle(color: scheme.onSurface.withOpacity(0.5), fontSize: 13)),
                  Text('$value', style: TextStyle(color: scheme.onSurface, fontSize: 40, fontWeight: FontWeight.w700)),
                  Text(label, style: TextStyle(color: scheme.onSurface.withOpacity(0.6), fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        _RoundIconButton(icon: Icons.add, onTap: value < max ? onIncrement : null),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: onTap == null ? scheme.onSurface.withOpacity(0.3) : scheme.onSurface),
        ),
      ),
    );
  }
}
