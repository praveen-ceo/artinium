class Room {
  final String id;
  final String name;
  final String imageAsset;
  final List<String> deviceIds;

  const Room({
    required this.id,
    required this.name,
    required this.imageAsset,
    this.deviceIds = const [],
  });

  int get deviceCount => deviceIds.length;
}
