enum AiSender { user, assistant }

enum AiVoiceState { idle, listening, processing, responding }

class AiMessage {
  final String id;
  final AiSender sender;
  final String text;
  final DateTime timestamp;

  const AiMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

/// Parsed result of an AI command, mirroring the intended
/// voice -> STT -> AI -> intent -> device service pipeline.
class AiIntent {
  final String type; // e.g. device_control, query_energy, run_automation
  final String? roomId;
  final String? deviceType;
  final String? action; // on/off/set
  final Map<String, dynamic> parameters;

  const AiIntent({
    required this.type,
    this.roomId,
    this.deviceType,
    this.action,
    this.parameters = const {},
  });
}
