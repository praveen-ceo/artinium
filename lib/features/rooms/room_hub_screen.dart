import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/repositories/device_repository.dart';
import '../../data/repositories/energy_repository.dart';
import '../../data/repositories/room_repository.dart';
import '../../shared/widgets/device_tile.dart';
import '../../shared/widgets/energy_card.dart';
import '../../shared/widgets/state_views.dart';

class RoomHubScreen extends StatelessWidget {
  final String roomId;
  const RoomHubScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final room = context.read<RoomRepository>().byId(roomId);

    if (room == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const InfoStateView.empty(title: 'Room not found'),
      );
    }

    final deviceRepo = context.watch<DeviceRepository>();
    final devices = deviceRepo.forRoom(roomId);
    final snapshot = context.read<EnergyRepository>().current();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: scheme.surface,
            leading: const BackButton(),
            actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF232B38), Color(0xFF12161D)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.lg,
                    bottom: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room.name, style: AppTextStyles.h1(Colors.white)),
                        Text('${devices.length} Devices', style: AppTextStyles.body(Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (devices.isEmpty)
                  const InfoStateView.empty(title: 'No devices in this room yet')
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: devices.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, i) {
                      final d = devices[i];
                      return DeviceTile(
                        device: d,
                        onToggle: () => deviceRepo.toggle(d.id),
                        onOpen: () => Navigator.of(context).pushNamed(AppRoutes.deviceControl, arguments: d.id),
                      );
                    },
                  ),
                const SizedBox(height: AppSpacing.lg),
                EnergyCard(todayUnits: snapshot.todayUnits, history: snapshot.last7Days),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
