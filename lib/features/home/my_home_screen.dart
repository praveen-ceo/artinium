import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/repositories/room_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/room_card.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final roomRepo = context.read<RoomRepository>();
    final rooms = roomRepo.all();
    final totalDevices = roomRepo.totalDeviceCount();
    final userName = context.watch<UserRepository>().user.name;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Home', style: AppTextStyles.h1(scheme.onSurface)),
                      Text('${rooms.length} Rooms • $totalDevices Devices',
                          style: AppTextStyles.body(scheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ),
                Text('Hi, $userName', style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.5))),
                const SizedBox(width: AppSpacing.sm),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: scheme.surface,
                  child: Icon(Icons.notifications_outlined, color: scheme.onSurface.withOpacity(0.7), size: 18),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.82,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final room = rooms[i];
                return RoomCard(
                  room: room,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.roomHub, arguments: room.id),
                );
              },
              childCount: rooms.length,
            ),
          ),
        ),
      ],
    );
  }
}
