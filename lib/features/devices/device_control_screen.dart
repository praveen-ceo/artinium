import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/device_repository.dart';
import '../../data/repositories/room_repository.dart';
import '../../models/device.dart';
import '../../shared/widgets/state_views.dart';
import 'widgets/ac_control_view.dart';
import 'widgets/fan_control_view.dart';
import 'widgets/light_control_view.dart';

class DeviceControlScreen extends StatelessWidget {
  final String deviceId;
  const DeviceControlScreen({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final deviceRepo = context.watch<DeviceRepository>();
    final device = deviceRepo.byId(deviceId);
    final scheme = Theme.of(context).colorScheme;

    if (device == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const InfoStateView.empty(title: 'Device not found'),
      );
    }

    final room = context.read<RoomRepository>().byId(device.roomId);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${device.type.label} Control', style: AppTextStyles.h2(scheme.onSurface)),
            if (room != null) Text(room.name, style: AppTextStyles.caption(scheme.onSurface.withOpacity(0.55))),
          ],
        ),
      ),
      body: device.status == DeviceStatus.offline
          ? InfoStateView.offline(
              title: '${device.name} is offline',
              subtitle: 'Check the device power and network connection, then try again.',
              actionLabel: 'Retry',
              onAction: () {},
            )
          : SafeArea(child: SingleChildScrollView(child: _buildControl(device, deviceRepo))),
    );
  }

  Widget _buildControl(Device device, DeviceRepository repo) {
    switch (device.type) {
      case DeviceType.fan:
        return FanControlView(device: device, repo: repo);
      case DeviceType.ac:
        return AcControlView(device: device, repo: repo);
      case DeviceType.light:
        return LightControlView(device: device, repo: repo);
      case DeviceType.tv:
      case DeviceType.curtain:
      case DeviceType.airPurifier:
        return LightControlView(device: device, repo: repo); // shares on/off + basic UI for simple devices
    }
  }
}
