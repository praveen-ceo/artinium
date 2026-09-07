import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../models/room.dart';

/// Renders a single room. My Home builds a grid of these from
/// [RoomRepository.all] — never hardcode one card per room.
class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomCard({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.onSurface.withOpacity(0.06),
                scheme.onSurface.withOpacity(0.02),
              ],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: _RoomImagePlaceholder(roomName: room.name),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${room.deviceCount} Devices',
                          style: TextStyle(color: scheme.onSurface.withOpacity(0.55), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurface.withOpacity(0.4), size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Until real photography assets are bundled, render a soft gradient tile
/// with a room-appropriate icon so layouts never depend on network images.
class _RoomImagePlaceholder extends StatelessWidget {
  final String roomName;
  const _RoomImagePlaceholder({required this.roomName});

  IconData get _icon {
    switch (roomName.toLowerCase()) {
      case 'bedroom':
        return Icons.bed_outlined;
      case 'living room':
        return Icons.weekend_outlined;
      case 'kitchen':
        return Icons.kitchen_outlined;
      case 'hall':
        return Icons.door_front_door_outlined;
      case 'bathroom':
        return Icons.bathtub_outlined;
      case 'balcony':
        return Icons.balcony_outlined;
      case 'terrace':
        return Icons.deck_outlined;
      case 'portico':
        return Icons.garage_outlined;
      default:
        return Icons.house_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF232B38), Color(0xFF12161D)],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(_icon, color: AppColors.gold.withOpacity(0.85), size: 32),
    );
  }
}
