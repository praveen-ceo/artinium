class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String colorTone;
  final String comfortLevel;
  final int powerTargetUnits;
  final String tariffRegion;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.colorTone = 'Gold',
    this.comfortLevel = 'MEDIUM',
    this.powerTargetUnits = 200,
    this.tariffRegion = 'Tamil Nadu (TN)',
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? colorTone,
    String? comfortLevel,
    int? powerTargetUnits,
    String? tariffRegion,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      colorTone: colorTone ?? this.colorTone,
      comfortLevel: comfortLevel ?? this.comfortLevel,
      powerTargetUnits: powerTargetUnits ?? this.powerTargetUnits,
      tariffRegion: tariffRegion ?? this.tariffRegion,
    );
  }
}
