import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/repositories/energy_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/energy_service.dart';
import '../../shared/widgets/energy_card.dart';

class EnergyScreen extends StatelessWidget {
  final bool detailed;
  const EnergyScreen({super.key, this.detailed = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final snapshot = context.read<EnergyRepository>().current();
    final region = context.watch<UserRepository>().user.tariffRegion;
    final insight = EnergyService().topConsumerInsight(snapshot);

    final content = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!detailed) Text('Energy', style: AppTextStyles.h1(scheme.onSurface)),
          if (!detailed) const SizedBox(height: AppSpacing.lg),
          PowerTargetCard(region: region, snapshot: snapshot),
          const SizedBox(height: AppSpacing.md),
          EnergyCard(todayUnits: snapshot.todayUnits, history: snapshot.last7Days),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.ai.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.ai.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.insights_outlined, color: AppColors.ai),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(insight, style: AppTextStyles.body(scheme.onSurface))),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Top Consuming Devices', style: AppTextStyles.h2(scheme.onSurface)),
          const SizedBox(height: AppSpacing.sm),
          ...snapshot.topDevices.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.deviceName, style: AppTextStyles.bodyStrong(scheme.onSurface)),
                            Text(d.roomName, style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5))),
                          ],
                        ),
                      ),
                      Text('${d.units.toStringAsFixed(1)} Units', style: AppTextStyles.bodyStrong(AppColors.gold)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );

    if (!detailed) return content;
    return Scaffold(appBar: AppBar(title: const Text('Energy Details')), body: content);
  }
}
