import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_provider.dart';

class VoiceControlButton extends StatelessWidget {
  final double size;
  final Color? color;

  const VoiceControlButton({
    super.key,
    this.size = 56.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, child) {
        return GestureDetector(
          onTapDown: (_) => voiceProvider.startListening(),
          onTapUp: (_) => voiceProvider.stopListening(),
          onTapCancel: () => voiceProvider.stopListening(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: voiceProvider.isListening
                    ? Colors.red
                    : color ?? Theme.of(context).primaryColor,
              ),
              child: Icon(
                voiceProvider.isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: size * 0.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
