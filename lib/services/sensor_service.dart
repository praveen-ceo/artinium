import 'dart:math';
import '../models/sensor.dart';

/// Mock sensor feed keyed by room. A real implementation would subscribe
/// to MqttService topics published by ESP32 devices and map payloads into
/// the same [SensorReading] shape.
abstract class SensorService {
  Map<SensorType, SensorReading> readingsForRoom(String roomId);
}

class MockSensorService implements SensorService {
  final _rand = Random(7);

  @override
  Map<SensorType, SensorReading> readingsForRoom(String roomId) {
    final now = DateTime.now();
    return {
      SensorType.motion: SensorReading(
        roomId: roomId,
        type: SensorType.motion,
        value: _rand.nextBool(),
        timestamp: now,
      ),
      SensorType.temperature: SensorReading(
        roomId: roomId,
        type: SensorType.temperature,
        value: 22 + _rand.nextInt(5),
        timestamp: now,
      ),
      SensorType.humidity: SensorReading(
        roomId: roomId,
        type: SensorType.humidity,
        value: 40 + _rand.nextInt(20),
        timestamp: now,
      ),
    };
  }
}
