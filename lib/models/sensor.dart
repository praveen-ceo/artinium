enum SensorType { motion, temperature, humidity, power }

/// Mock sensor reading. Interface stays stable so a real ESP32/MQTT feed
/// can populate the same shape later (see SensorService).
class SensorReading {
  final String roomId;
  final SensorType type;
  final dynamic value; // bool for motion, double for temp/humidity/power
  final DateTime timestamp;

  const SensorReading({
    required this.roomId,
    required this.type,
    required this.value,
    required this.timestamp,
  });
}
