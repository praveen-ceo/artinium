import 'package:flutter_test/flutter_test.dart';
import 'package:artinium/models/energy.dart';
import 'package:artinium/services/energy_service.dart';

void main() {
  group('EnergySnapshot', () {
    test('percentUsed and unitsRemaining compute correctly', () {
      const snapshot = EnergySnapshot(
        unitsConsumed: 82,
        targetUnits: 200,
        todayUnits: 2.4,
        last7Days: [],
        topDevices: [],
      );
      expect(snapshot.percentUsed, closeTo(41.0, 0.01));
      expect(snapshot.unitsRemaining, 118);
    });

    test('unitsRemaining never goes negative when over target', () {
      const snapshot = EnergySnapshot(
        unitsConsumed: 250,
        targetUnits: 200,
        todayUnits: 5,
        last7Days: [],
        topDevices: [],
      );
      expect(snapshot.unitsRemaining, 0);
      expect(snapshot.percentUsed, 100);
    });
  });

  group('EnergyService', () {
    test('topConsumerInsight names the highest-usage device', () {
      const snapshot = EnergySnapshot(
        unitsConsumed: 82,
        targetUnits: 200,
        todayUnits: 2.4,
        last7Days: [],
        topDevices: [
          DeviceUsage(deviceName: 'AC', roomName: 'Bedroom', units: 34.2),
          DeviceUsage(deviceName: 'Fan', roomName: 'Hall', units: 8.9),
        ],
      );
      final insight = EnergyService().topConsumerInsight(snapshot);
      expect(insight, contains('Bedroom'));
      expect(insight, contains('AC'));
    });
  });
}
