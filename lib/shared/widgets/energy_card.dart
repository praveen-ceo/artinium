import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../models/energy.dart';

/// Small "today's usage" card with a sparkline, used on the Room Control
/// Hub and Home screen.
class EnergyCard extends StatelessWidget {
  final double todayUnits;
  final List<EnergyPoint> history;

  const EnergyCard({super.key, required this.todayUnits, required this.history});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Power Usage', style: TextStyle(color: scheme.onSurface.withOpacity(0.6), fontSize: 13)),
                const SizedBox(height: 4),
                Text('Today', style: TextStyle(color: scheme.onSurface.withOpacity(0.6), fontSize: 12)),
                Text(
                  '${todayUnits.toStringAsFixed(1)} Units',
                  style: TextStyle(color: scheme.onSurface, fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(width: 100, height: 44, child: CustomPaint(painter: _Sparkline(history))),
        ],
      ),
    );
  }
}

class _Sparkline extends CustomPainter {
  final List<EnergyPoint> points;
  _Sparkline(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxVal = points.map((p) => p.units).reduce((a, b) => a > b ? a : b);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height - (points[i].units / (maxVal == 0 ? 1 : maxVal)) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.success
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _Sparkline oldDelegate) => oldDelegate.points != points;
}

/// Power-target progress card shown in Personalization and Energy screens.
class PowerTargetCard extends StatelessWidget {
  final String region;
  final EnergySnapshot snapshot;
  final VoidCallback? onEdit;

  const PowerTargetCard({super.key, required this.region, required this.snapshot, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(region, style: TextStyle(color: scheme.onSurface.withOpacity(0.6), fontSize: 13)),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: const Row(
                    children: [
                      Text('Edit', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.edit_outlined, size: 14, color: AppColors.gold),
                    ],
                  ),
                ),
            ],
          ),
          Text(
            '${snapshot.targetUnits} Units / Month',
            style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: snapshot.percentUsed / 100,
              minHeight: 8,
              backgroundColor: scheme.onSurface.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${snapshot.unitsConsumed.toStringAsFixed(0)} Units Consumed',
                  style: TextStyle(color: scheme.onSurface.withOpacity(0.6), fontSize: 12)),
              Text('${snapshot.unitsRemaining.toStringAsFixed(0)} Units Remaining',
                  style: TextStyle(color: scheme.onSurface.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
