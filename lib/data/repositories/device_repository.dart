import 'package:flutter/foundation.dart';
import '../../models/automation.dart';
import '../../models/device.dart';
import '../mock/mock_data.dart';

/// Owns device state for the app. Today it's backed by an in-memory mock
/// list; swap the body of these methods for ApiService/MqttService calls
/// later without touching the UI, since the public surface stays the same.
class DeviceRepository extends ChangeNotifier {
  final Map<String, Device> _devices = {
    for (final d in MockData.devices) d.id: d,
  };

  List<Device> all() => _devices.values.toList();

  List<Device> forRoom(String roomId) =>
      _devices.values.where((d) => d.roomId == roomId).toList();

  Device? byId(String id) => _devices[id];

  void toggle(String deviceId) {
    final d = _devices[deviceId];
    if (d == null) return;
    _devices[deviceId] = d.copyWith(isOn: !d.isOn);
    notifyListeners();
  }

  void setOn(String deviceId, bool on) {
    final d = _devices[deviceId];
    if (d == null) return;
    _devices[deviceId] = d.copyWith(isOn: on);
    notifyListeners();
  }

  void setAttribute(String deviceId, String key, dynamic value) {
    final d = _devices[deviceId];
    if (d == null) return;
    _devices[deviceId] = d.withAttribute(key, value);
    notifyListeners();
  }

  void setFanSpeed(String deviceId, int speed) {
    final clamped = speed.clamp(1, 5);
    setAttribute(deviceId, 'speed', clamped);
  }

  void applyAutomation(Automation automation) {
    for (final entry in automation.actions.entries) {
      final d = _devices[entry.key];
      if (d == null) continue;
      var next = d;
      entry.value.forEach((key, value) {
        if (key == 'isOn') {
          next = next.copyWith(isOn: value as bool);
        } else {
          next = next.withAttribute(key, value);
        }
      });
      _devices[entry.key] = next;
    }
    notifyListeners();
  }
}
