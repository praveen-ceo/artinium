class AppConstants {
  AppConstants._();

  static const String appName = 'ARTINIUM';
  static const String tagline = 'SMART HOME. FUTURISTIC LIVING.';
  static const String aiName = 'Artinian AI';

  /// Comfort-level labels shown to users instead of raw temperatures.
  /// Backed by [comfortToCelsius] so the actual degrees stay configurable
  /// and can later be wired to a real AC service.
  static const List<String> comfortLevels = ['HOT', 'WARM', 'MEDIUM', 'COOL'];

  static const Map<String, double> comfortToCelsius = {
    'HOT': 26,
    'WARM': 24,
    'MEDIUM': 22,
    'COOL': 19,
  };

  static const List<String> colorTones = [
    'Warm',
    'Bright',
    'Gold',
    'Green',
    'Red',
  ];
}
