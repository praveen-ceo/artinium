/// A data-driven automation: applying it sets a batch of device attributes
/// rather than being hardcoded into individual widgets. `actions` maps
/// deviceId -> { isOn / attribute changes } and is interpreted by
/// DeviceRepository.applyAutomation.
class Automation {
  final String id;
  final String name;
  final String description;
  final String icon; // Material icon name key, resolved in UI layer
  final Map<String, Map<String, dynamic>> actions;

  const Automation({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.actions,
  });
}
