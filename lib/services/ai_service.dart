import '../models/ai_message.dart';

/// Turns free-text (from typing or the mock voice pipeline) into an
/// [AiIntent] and a spoken/displayed reply. Swap [MockAiService] for a
/// real LLM-backed implementation later; never put API keys in the
/// Flutter client — route real calls through the backend.
abstract class AiService {
  Future<(AiIntent, String)> process(String input);
}

class MockAiService implements AiService {
  @override
  Future<(AiIntent, String)> process(String input) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final text = input.toLowerCase();

    if (text.contains('power usage') || text.contains('energy')) {
      return (
        const AiIntent(type: 'query_energy'),
        "You've used 82 of your 200 unit target this month — 41%.",
      );
    }
    if (text.contains('good night')) {
      return (
        const AiIntent(type: 'run_automation', parameters: {'id': 'good_night'}),
        'Sure — activating Good Night mode now.',
      );
    }

    final room = _matchRoom(text);
    final device = _matchDevice(text);
    final action = text.contains('off') ? 'off' : 'on';

    if (text.contains('cool')) {
      return (
        AiIntent(type: 'device_control', roomId: room, deviceType: 'ac', action: 'set', parameters: const {'mode': 'COOL'}),
        'Setting the AC to cool mode.',
      );
    }

    if (room != null && device != null) {
      return (
        AiIntent(type: 'device_control', roomId: room, deviceType: device, action: action),
        'Turning ${action == 'on' ? 'on' : 'off'} the $room $device.',
      );
    }

    return (
      const AiIntent(type: 'unknown'),
      "I didn't catch a device or room in that — try something like "
          '"turn on the living room lights".',
    );
  }

  String? _matchRoom(String text) {
    const rooms = ['bedroom', 'living room', 'kitchen', 'hall', 'bathroom', 'balcony', 'terrace', 'portico'];
    for (final r in rooms) {
      if (text.contains(r)) return r;
    }
    return null;
  }

  String? _matchDevice(String text) {
    const devices = ['light', 'fan', 'ac', 'tv', 'curtain', 'purifier'];
    for (final d in devices) {
      if (text.contains(d)) return d;
    }
    return null;
  }
}
