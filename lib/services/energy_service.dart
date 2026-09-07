import '../models/energy.dart';

/// Derives simple, clearly-labeled insights from an [EnergySnapshot].
/// Keeps recommendation copy conservative — no unsupported savings claims.
class EnergyService {
  String topConsumerInsight(EnergySnapshot snapshot) {
    if (snapshot.topDevices.isEmpty) return 'No device usage data yet.';
    final top = snapshot.topDevices.first;
    return 'Your ${top.roomName} ${top.deviceName} is currently your '
        'highest energy-consuming device.';
  }

  bool isNearTarget(EnergySnapshot snapshot) => snapshot.percentUsed >= 80;
}
