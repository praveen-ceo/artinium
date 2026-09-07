import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/device_repository.dart';
import '../../models/ai_message.dart';
import '../../services/ai_service.dart';
import '../../services/voice_service.dart';
import 'package:artinium/models/device.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> with SingleTickerProviderStateMixin {
  final AiService _ai = MockAiService();
  final VoiceService _voice = MockVoiceService();
  final TextEditingController _inputCtrl = TextEditingController();
  final List<AiMessage> _messages = [];
  AiVoiceState _state = AiVoiceState.idle;
  late final AnimationController _pulse;

  static const _examples = [
    'Turn on the living room lights',
    'Set bedroom AC to cool mode',
    "What's my power usage today?",
    'Activate Good Night mode',
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendText(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(AiMessage(id: 't${_messages.length}', sender: AiSender.user, text: text, timestamp: DateTime.now()));
      _state = AiVoiceState.processing;
      _inputCtrl.clear();
    });
    final (intent, reply) = await _ai.process(text);
    _applyIntent(intent);
    if (!mounted) return;
    setState(() {
      _messages.add(AiMessage(id: 'r${_messages.length}', sender: AiSender.assistant, text: reply, timestamp: DateTime.now()));
      _state = AiVoiceState.idle;
    });
  }

  Future<void> _startListening() async {
    setState(() => _state = AiVoiceState.listening);
    final transcript = await _voice.listenOnce();
    if (!mounted) return;
    await _sendText(transcript);
  }

  void _applyIntent(AiIntent intent) {
    final deviceRepo = context.read<DeviceRepository>();
    if (intent.type == 'run_automation') {
      final id = intent.parameters['id'];
      final automation = MockData.automations.where((a) => a.id == id).firstOrNull;
      if (automation != null) deviceRepo.applyAutomation(automation);
      return;
    }
    if (intent.type == 'device_control' && intent.roomId != null && intent.deviceType != null) {
      final match = deviceRepo
          .all()
          .where((d) => d.roomId.replaceAll('_', ' ') == intent.roomId && d.type.label.toLowerCase().contains(intent.deviceType!))
          .toList();
      for (final d in match) {
        if (intent.action == 'off') {
          deviceRepo.setOn(d.id, false);
        } else if (intent.action == 'set') {
          deviceRepo.setOn(d.id, true);
          intent.parameters.forEach((k, v) => deviceRepo.setAttribute(d.id, k, v));
        } else {
          deviceRepo.setOn(d.id, true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppConstants.aiName, style: AppTextStyles.h1(scheme.onSurface)),
                      Text('AI Assistant', style: AppTextStyles.body(scheme.onSurface.withOpacity(0.55))),
                    ],
                  ),
                ),
                Icon(Icons.tune, color: scheme.onSurface.withOpacity(0.6)),
              ],
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? _buildIdleBody(scheme)
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) => _MessageBubble(message: _messages[i]),
                  ),
          ),
          _buildInputBar(scheme),
        ],
      ),
    );
  }

  Widget _buildIdleBody(ColorScheme scheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final scale = _state == AiVoiceState.listening ? 1.0 + _pulse.value * 0.08 : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.ai.withOpacity(0.35), AppColors.ai.withOpacity(0.02)],
              ),
            ),
            child: Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ai, width: 2),
                  boxShadow: [BoxShadow(color: AppColors.ai.withOpacity(0.4), blurRadius: 24)],
                ),
                child: Icon(
                  _state == AiVoiceState.processing ? Icons.hourglass_top : Icons.graphic_eq,
                  color: AppColors.ai,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('How can I help you?', style: AppTextStyles.h2(scheme.onSurface)),
        const SizedBox(height: AppSpacing.sm),
        Text('You can say something like:', style: AppTextStyles.body(scheme.onSurface.withOpacity(0.55))),
        const SizedBox(height: AppSpacing.md),
        ..._examples.map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
              child: InkWell(
                onTap: () => _sendText(e),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(e, style: AppTextStyles.body(scheme.onSurface))),
                      Icon(Icons.chevron_right, color: scheme.onSurface.withOpacity(0.4), size: 18),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildInputBar(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_outlined, color: scheme.onSurface.withOpacity(0.6)),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              style: TextStyle(color: scheme.onSurface),
              decoration: const InputDecoration(hintText: 'Ask Artinian AI...'),
              onSubmitted: _sendText,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: _state == AiVoiceState.listening ? null : _startListening,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.ai,
              child: Icon(
                _state == AiVoiceState.listening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.history, color: scheme.onSurface.withOpacity(0.6)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AiMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == AiSender.user;
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? AppColors.gold.withOpacity(0.18) : scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isUser ? AppColors.gold.withOpacity(0.4) : scheme.onSurface.withOpacity(0.08)),
        ),
        child: Text(message.text, style: TextStyle(color: scheme.onSurface)),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
