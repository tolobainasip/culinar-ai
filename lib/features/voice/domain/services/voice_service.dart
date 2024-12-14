import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Ошибка распознавания: $error'),
        onStatus: (status) => print('Статус распознавания: $status'),
      );

      await _flutterTts.setLanguage('ru-RU');
      await _flutterTts.setSpeechRate(0.9);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    }
  }

  Future<bool> startListening(Function(String) onResult) async {
    if (!_isInitialized) {
      await initialize();
    }

    return await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'ru_RU',
      cancelOnError: true,
      partialResults: false,
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
}
