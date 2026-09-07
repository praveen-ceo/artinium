import 'package:flutter_test/flutter_test.dart';
import 'package:artinium/data/repositories/device_repository.dart';
import 'package:artinium/data/mock/mock_data.dart';

void main() {
  group('DeviceRepository', () {
    late DeviceRepository repo;

    setUp(() {
      repo = DeviceRepository();
    });

    test('toggle flips isOn state', () {
      final before = repo.byId('bed_fan')!.isOn;
      repo.toggle('bed_fan');
      expect(repo.byId('bed_fan')!.isOn, !before);
    });

    test('setFanSpeed clamps to 1-5', () {
      repo.setFanSpeed('bed_fan', 10);
      expect(repo.byId('bed_fan')!.fanSpeed, 5);

      repo.setFanSpeed('bed_fan', -3);
      expect(repo.byId('bed_fan')!.fanSpeed, 1);

      repo.setFanSpeed('bed_fan', 3);
      expect(repo.byId('bed_fan')!.fanSpeed, 3);
    });

    test('forRoom returns only that room\'s devices', () {
      final devices = repo.forRoom('bedroom');
      expect(devices.every((d) => d.roomId == 'bedroom'), true);
      expect(devices.length, 4);
    });

    test('applyAutomation (Good Night) turns off lights/fans/ACs', () {
      final goodNight = MockData.automations.firstWhere((a) => a.id == 'good_night');
      repo.applyAutomation(goodNight);
      expect(repo.byId('bed_light')!.isOn, false);
      expect(repo.byId('bed_fan')!.isOn, false);
      expect(repo.byId('bed_ac')!.isOn, false);
      // Curtains aren't part of Good Night's action set.
      expect(repo.byId('lr_curtain'), isNotNull);
    });
  });
}
