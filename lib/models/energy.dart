class EnergyPoint {
  final DateTime time;
  final double units;
  const EnergyPoint(this.time, this.units);
}

class DeviceUsage {
  final String deviceName;
  final String roomName;
  final double units;
  const DeviceUsage({
    required this.deviceName,
    required this.roomName,
    required this.units,
  });
}

/// Aggregate energy state for the current billing cycle. [targetUnits] is
/// a user-configurable demo value, never a guaranteed government figure.
class EnergySnapshot {
  final double unitsConsumed;
  final int targetUnits;
  final double todayUnits;
  final List<EnergyPoint> last7Days;
  final List<DeviceUsage> topDevices;

  const EnergySnapshot({
    required this.unitsConsumed,
    required this.targetUnits,
    required this.todayUnits,
    required this.last7Days,
    required this.topDevices,
  });

  double get unitsRemaining =>
      (targetUnits - unitsConsumed).clamp(0, targetUnits).toDouble();

  double get percentUsed =>
      targetUnits == 0 ? 0 : (unitsConsumed / targetUnits).clamp(0, 1) * 100;
}
