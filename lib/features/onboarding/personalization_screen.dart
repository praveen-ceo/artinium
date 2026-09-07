import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/repositories/energy_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/energy_card.dart';
import '../../shared/widgets/primary_button.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  late String _colorTone;
  late String _comfort;
  late int _target;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserRepository>().user;
    _colorTone = user.colorTone;
    _comfort = user.comfortLevel;
    _target = user.powerTargetUnits;
  }

  Future<void> _editTarget() async {
    final controller = TextEditingController(text: _target.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        title: const Text('Monthly Unit Target'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'Units / Month'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(controller.text) ?? _target),
            child: const Text('Save', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
    if (result != null && result > 0) setState(() => _target = result);
  }

  void _continue() {
    context.read<UserRepository>().updatePersonalization(
          colorTone: _colorTone,
          comfortLevel: _comfort,
          powerTargetUnits: _target,
        );
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final snapshot = context.read<EnergyRepository>().current();
    final adjustedSnapshot = snapshot.targetUnits == _target
        ? snapshot
        : (snapshot); // demo target only changes the card's target label pre-save

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Personalize Your Experience', style: AppTextStyles.h1(scheme.onSurface)),
              const SizedBox(height: 4),
              Text('Set your preferred ambience and comfort.',
                  style: AppTextStyles.body(scheme.onSurface.withOpacity(0.6))),
              const SizedBox(height: AppSpacing.xl),

              Text('1. Choose Colour Tone', style: AppTextStyles.h2(scheme.onSurface)),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 76,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.colorTones.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final tone = AppConstants.colorTones[i];
                    return _ToneChip(
                      label: tone,
                      color: _toneColor(tone),
                      selected: _colorTone == tone,
                      onTap: () => setState(() => _colorTone = tone),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text('2. Comfort Level', style: AppTextStyles.h2(scheme.onSurface)),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: AppConstants.comfortLevels.map((level) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _ComfortChip(
                        label: level,
                        selected: _comfort == level,
                        onTap: () => setState(() => _comfort = level),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Artinium adjusts the actual temperature automatically.',
                style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              Text('3. Power Usage Target', style: AppTextStyles.h2(scheme.onSurface)),
              const SizedBox(height: 4),
              Text(
                'Set your free units target according to your state.',
                style: AppTextStyles.body(scheme.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: AppSpacing.sm),
              PowerTargetCard(
                region: context.watch<UserRepository>().user.tariffRegion,
                snapshot: adjustedSnapshot,
                onEdit: _editTarget,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Artinium helps you stay within your target through smart energy optimization.',
                style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              PrimaryButton(label: 'CONTINUE', onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }

  Color _toneColor(String tone) {
    switch (tone) {
      case 'Warm':
        return const Color(0xFFE8834A);
      case 'Bright':
        return const Color(0xFF4A9CE8);
      case 'Gold':
        return AppColors.gold;
      case 'Green':
        return AppColors.success;
      case 'Red':
        return AppColors.error;
      default:
        return AppColors.gold;
    }
  }
}

class _ToneChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ToneChip({required this.label, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.18),
              border: Border.all(color: selected ? AppColors.gold : Colors.transparent, width: 2),
              boxShadow: selected ? [BoxShadow(color: AppColors.gold.withOpacity(0.35), blurRadius: 12)] : null,
            ),
            child: Icon(selected ? Icons.check : Icons.circle, color: color, size: selected ? 22 : 16),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }
}

class _ComfortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ComfortChip({required this.label, required this.selected, required this.onTap});

  IconData get _icon {
    switch (label) {
      case 'HOT':
        return Icons.local_fire_department_outlined;
      case 'WARM':
        return Icons.wb_sunny_outlined;
      case 'MEDIUM':
        return Icons.brightness_medium_outlined;
      default:
        return Icons.ac_unit_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold.withOpacity(0.15) : scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Icon(_icon, color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.6), size: 20),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: selected ? AppColors.gold : scheme.onSurface.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
