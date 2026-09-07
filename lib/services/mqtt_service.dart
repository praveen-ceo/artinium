/// Abstraction for the future MQTT broker link (Flutter -> Backend -> MQTT
/// -> ESP32/Raspberry Pi -> relays). The mock just logs/no-ops; a real
/// implementation (e.g. mqtt_client package) can implement this interface
/// without any change to DeviceRepository or the UI.
abstract class MqttService {
  Future<void> connect();
  Future<void> publish(String topic, Map<String, dynamic> payload);
  Stream<Map<String, dynamic>> subscribe(String topic);
  Future<void> disconnect();
}

class MockMqttService implements MqttService {
  @override
  Future<void> connect() async {}

  @override
  Future<void> publish(String topic, Map<String, dynamic> payload) async {
    // No-op in prototype: real hardware is not actually being controlled.
  }

  @override
  Stream<Map<String, dynamic>> subscribe(String topic) => const Stream.empty();

  @override
  Future<void> disconnect() async {}
}
