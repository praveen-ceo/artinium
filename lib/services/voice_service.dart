/// Abstraction over speech-to-text capture. The mock simulates a short
/// listening delay and returns a canned transcript; wire a real STT
/// plugin (e.g. speech_to_text) behind this interface later.
abstract class VoiceService {
  Future<String> listenOnce();
}

class MockVoiceService implements VoiceService {
  @override
  Future<String> listenOnce() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Turn on the living room lights';
  }
}
