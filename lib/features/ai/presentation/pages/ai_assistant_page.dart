import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final _questionController = TextEditingController();
  final _stt = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    await _stt.initialize();
  }

  Future<void> _startListening() async {
    if (await _stt.initialize()) {
      await _stt.listen(
        onResult: (result) {
          setState(() {
            _questionController.text = result.recognizedWords;
          });
        },
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  Future<void> _stopListening() async {
    await _stt.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кулинарный ассистент'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Задайте вопрос или опишите ингредиенты...',
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final response = await context
                    .read<AIProvider>()
                    .askCulinaryQuestion(_questionController.text);
                if (response != null) {
                  // Показываем ответ
                }
              },
              child: const Text('Получить рекомендацию'),
            ),
            const SizedBox(height: 16),
            Consumer<AIProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.isLoading) {
                  return const CircularProgressIndicator();
                }
                if (aiProvider.lastError != null) {
                  return Text(
                    'Ошибка: ${aiProvider.lastError}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                if (aiProvider.currentRecipe != null) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Text(aiProvider.currentRecipe!),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
