import '../../models/automation.dart';
import '../../models/device.dart';
import '../../models/energy.dart';
import '../../models/room.dart';
import '../../models/user.dart';

/// Static seed data for the prototype. Repositories copy this into mutable
/// in-memory state; nothing here should be mutated directly.
class MockData {
  MockData._();

  static const AppUser user = AppUser(
    id: 'u1',
    name: 'Praveen',
    email: 'praveen@artinium.com',
  );

  static final List<Room> rooms = [
    const Room(id: 'bedroom', name: 'Bedroom', imageAsset: 'assets/images/bedroom.jpg', deviceIds: ['bed_light', 'bed_fan', 'bed_ac', 'bed_curtain']),
    const Room(id: 'living_room', name: 'Living Room', imageAsset: 'assets/images/living_room.jpg', deviceIds: ['lr_light', 'lr_fan', 'lr_ac', 'lr_tv', 'lr_curtain', 'lr_purifier']),
    const Room(id: 'kitchen', name: 'Kitchen', imageAsset: 'assets/images/kitchen.jpg', deviceIds: ['kit_light', 'kit_fan', 'kit_purifier']),
    const Room(id: 'hall', name: 'Hall', imageAsset: 'assets/images/hall.jpg', deviceIds: ['hall_light', 'hall_fan', 'hall_ac']),
    const Room(id: 'bathroom', name: 'Bathroom', imageAsset: 'assets/images/bathroom.jpg', deviceIds: ['bath_light', 'bath_fan']),
    const Room(id: 'balcony', name: 'Balcony', imageAsset: 'assets/images/balcony.jpg', deviceIds: ['bal_light', 'bal_fan']),
    const Room(id: 'terrace', name: 'Terrace', imageAsset: 'assets/images/terrace.jpg', deviceIds: ['ter_light', 'ter_fan']),
    const Room(id: 'portico', name: 'Portico', imageAsset: 'assets/images/portico.jpg', deviceIds: ['por_light', 'por_fan']),
  ];

  static final List<Device> devices = [
    // Bedroom
    const Device(id: 'bed_light', roomId: 'bedroom', name: 'Light', type: DeviceType.light, isOn: true, attributes: {'brightness': 70, 'ambience': 'Warm'}),
    const Device(id: 'bed_fan', roomId: 'bedroom', name: 'Fan', type: DeviceType.fan, isOn: true, attributes: {'speed': 3}),
    const Device(id: 'bed_ac', roomId: 'bedroom', name: 'AC', type: DeviceType.ac, isOn: true, attributes: {'mode': 'MEDIUM', 'speed': 2}),
    const Device(id: 'bed_curtain', roomId: 'bedroom', name: 'Curtains', type: DeviceType.curtain, isOn: false),
    // Living room
    const Device(id: 'lr_light', roomId: 'living_room', name: 'Lights', type: DeviceType.light, isOn: true, attributes: {'brightness': 85, 'ambience': 'Bright'}),
    const Device(id: 'lr_fan', roomId: 'living_room', name: 'Fan', type: DeviceType.fan, isOn: false, attributes: {'speed': 2}),
    const Device(id: 'lr_ac', roomId: 'living_room', name: 'AC', type: DeviceType.ac, isOn: false, attributes: {'mode': 'COOL', 'speed': 3}),
    const Device(id: 'lr_tv', roomId: 'living_room', name: 'TV', type: DeviceType.tv, isOn: false),
    const Device(id: 'lr_curtain', roomId: 'living_room', name: 'Curtains', type: DeviceType.curtain, isOn: true),
    const Device(id: 'lr_purifier', roomId: 'living_room', name: 'Air Purifier', type: DeviceType.airPurifier, isOn: true),
    // Kitchen
    const Device(id: 'kit_light', roomId: 'kitchen', name: 'Light', type: DeviceType.light, isOn: true, attributes: {'brightness': 90, 'ambience': 'Bright'}),
    const Device(id: 'kit_fan', roomId: 'kitchen', name: 'Exhaust Fan', type: DeviceType.fan, isOn: false, attributes: {'speed': 4}),
    const Device(id: 'kit_purifier', roomId: 'kitchen', name: 'Air Purifier', type: DeviceType.airPurifier, isOn: false),
    // Hall
    const Device(id: 'hall_light', roomId: 'hall', name: 'Light', type: DeviceType.light, isOn: true, attributes: {'brightness': 75, 'ambience': 'Warm'}),
    const Device(id: 'hall_fan', roomId: 'hall', name: 'Fan', type: DeviceType.fan, isOn: true, attributes: {'speed': 2}),
    const Device(id: 'hall_ac', roomId: 'hall', name: 'AC', type: DeviceType.ac, isOn: false, attributes: {'mode': 'MEDIUM', 'speed': 2}),
    // Bathroom
    const Device(id: 'bath_light', roomId: 'bathroom', name: 'Light', type: DeviceType.light, isOn: false, attributes: {'brightness': 60}),
    const Device(id: 'bath_fan', roomId: 'bathroom', name: 'Exhaust Fan', type: DeviceType.fan, isOn: false, attributes: {'speed': 3}, status: DeviceStatus.offline),
    // Balcony
    const Device(id: 'bal_light', roomId: 'balcony', name: 'Light', type: DeviceType.light, isOn: false, attributes: {'brightness': 50}),
    const Device(id: 'bal_fan', roomId: 'balcony', name: 'Fan', type: DeviceType.fan, isOn: false, attributes: {'speed': 1}),
    // Terrace
    const Device(id: 'ter_light', roomId: 'terrace', name: 'Light', type: DeviceType.light, isOn: false, attributes: {'brightness': 65}),
    const Device(id: 'ter_fan', roomId: 'terrace', name: 'Fan', type: DeviceType.fan, isOn: false, attributes: {'speed': 1}),
    // Portico
    const Device(id: 'por_light', roomId: 'portico', name: 'Light', type: DeviceType.light, isOn: true, attributes: {'brightness': 80}),
    const Device(id: 'por_fan', roomId: 'portico', name: 'Fan', type: DeviceType.fan, isOn: false, attributes: {'speed': 1}),
  ];

  static EnergySnapshot energySnapshot() {
    final now = DateTime.now();
    return EnergySnapshot(
      unitsConsumed: 82,
      targetUnits: 200,
      todayUnits: 2.4,
      last7Days: List.generate(7, (i) {
        final day = now.subtract(Duration(days: 6 - i));
        const base = [9.8, 11.2, 8.4, 12.1, 10.6, 13.4, 2.4];
        return EnergyPoint(day, base[i]);
      }),
      topDevices: const [
        DeviceUsage(deviceName: 'AC', roomName: 'Bedroom', units: 34.2),
        DeviceUsage(deviceName: 'AC', roomName: 'Living Room', units: 21.7),
        DeviceUsage(deviceName: 'Fan', roomName: 'Hall', units: 8.9),
        DeviceUsage(deviceName: 'Air Purifier', roomName: 'Living Room', units: 6.1),
      ],
    );
  }

  static final List<Automation> automations = [
    Automation(
      id: 'good_night',
      name: 'Good Night',
      description: 'Turns off lights, fans and AC across the home.',
      icon: 'nightlight_round',
      actions: {
        for (final d in devices.where((d) => d.type == DeviceType.light || d.type == DeviceType.fan || d.type == DeviceType.ac))
          d.id: {'isOn': false},
      },
    ),
    const Automation(
      id: 'morning',
      name: 'Morning',
      description: 'Opens curtains and brings up bedroom and kitchen lights.',
      icon: 'wb_sunny_outlined',
      actions: {
        'bed_curtain': {'isOn': true},
        'bed_light': {'isOn': true, 'brightness': 60},
        'kit_light': {'isOn': true, 'brightness': 90},
      },
    ),
    Automation(
      id: 'away',
      name: 'Away Mode',
      description: 'Switches off non-essential devices when you leave.',
      icon: 'lock_outline',
      actions: {
        for (final d in devices.where((d) => d.type != DeviceType.airPurifier))
          d.id: {'isOn': false},
      },
    ),
    const Automation(
      id: 'energy_saver',
      name: 'Energy Saver',
      description: 'Caps AC and fan speeds to reduce consumption.',
      icon: 'bolt_outlined',
      actions: {
        'bed_ac': {'mode': 'WARM', 'speed': 1},
        'lr_ac': {'mode': 'WARM', 'speed': 1},
        'bed_fan': {'speed': 2},
      },
    ),
    const Automation(
      id: 'movie',
      name: 'Movie Mode',
      description: 'Dims living room lights and lowers curtains.',
      icon: 'movie_outlined',
      actions: {
        'lr_light': {'isOn': true, 'brightness': 15, 'ambience': 'Warm'},
        'lr_curtain': {'isOn': true},
        'lr_tv': {'isOn': true},
      },
    ),
  ];
}
