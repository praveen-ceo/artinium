enum DeviceType { light, fan, ac, tv, curtain, airPurifier }

enum DeviceStatus { online, offline }

extension DeviceTypeX on DeviceType {
  String get label {
    switch (this) {
      case DeviceType.light:
        return 'Light';
      case DeviceType.fan:
        return 'Fan';
      case DeviceType.ac:
        return 'AC';
      case DeviceType.tv:
        return 'TV';
      case DeviceType.curtain:
        return 'Curtains';
      case DeviceType.airPurifier:
        return 'Air Purifier';
    }
  }
}

/// A single device model used for every device type. Type-specific state
/// (brightness, fan speed, AC mode, timer) lives in [attributes] so no
/// duplicated per-type classes are needed. UI reads capabilities via the
/// typed getters/setters below.
class Device {
  final String id;
  final String roomId;
  final String name;
  final DeviceType type;
  final bool isOn;
  final DeviceStatus status;
  final Map<String, dynamic> attributes;

  const Device({
    required this.id,
    required this.roomId,
    required this.name,
    required this.type,
    this.isOn = false,
    this.status = DeviceStatus.online,
    this.attributes = const {},
  });

  // --- Capability accessors -------------------------------------------
  int get fanSpeed => (attributes['speed'] as int?) ?? 1;
  int get brightness => (attributes['brightness'] as int?) ?? 80;
  String get ambience => (attributes['ambience'] as String?) ?? 'Warm';
  String get acMode => (attributes['mode'] as String?) ?? 'MEDIUM';
  int? get timerMinutes => attributes['timerMinutes'] as int?;

  static const List<int> fanSpeedLabels = [1, 2, 3, 4, 5];
  String get fanSpeedLabel {
    switch (fanSpeed) {
      case 1:
        return 'Low';
      case 2:
        return 'Low-Medium';
      case 3:
        return 'Medium';
      case 4:
        return 'Medium-High';
      default:
        return 'High';
    }
  }

  Device copyWith({
    bool? isOn,
    DeviceStatus? status,
    Map<String, dynamic>? attributes,
  }) {
    return Device(
      id: id,
      roomId: roomId,
      name: name,
      type: type,
      isOn: isOn ?? this.isOn,
      status: status ?? this.status,
      attributes: attributes ?? this.attributes,
    );
  }

  Device withAttribute(String key, dynamic value) {
    final next = Map<String, dynamic>.from(attributes)..[key] = value;
    return copyWith(attributes: next);
  }
}
