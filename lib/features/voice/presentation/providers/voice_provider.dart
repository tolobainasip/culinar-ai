import 'package:flutter/foundation.dart';
import '../../domain/services/voice_service.dart';
import '../../../ai_assistant/presentation/providers/ai_assistant_provider.dart';

class VoiceProvider with ChangeNotifier {
  final VoiceService _voiceService;
  final AIAssistantProvider _aiProvider;
  bool _isListening = false;
  String _lastRecognizedWords = '';

  VoiceProvider(this._voiceService, this._aiProvider);

  bool get isListening => _isListening;
  String get lastRecognizedWords => _lastRecognizedWords;

  Future<void> toggleListening() async {
    if (_isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> startListening() async {
    final success = await _voiceService.startListening((recognizedWords) async {
      _lastRecognizedWords = recognizedWords;
      notifyListeners();

      // Анализируем команду
      if (_isRecipeQuery(recognizedWords)) {
        await _handleRecipeQuery(recognizedWords);
      } else if (_isIngredientQuery(recognizedWords)) {
        await _handleIngredientQuery(recognizedWords);
      } else if (_isStepQuery(recognizedWords)) {
        await _handleStepQuery(recognizedWords);
      }
    });

    if (success) {
      _isListening = true;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _voiceService.stopListening();
    _isListening = false;
    notifyListeners();
  }

  Future<void> speak(String text) async {
    await _voiceService.speak(text);
  }

  bool _isRecipeQuery(String text) {
    final keywords = [
      'приготовить',
      'рецепт',
      'как готовить',
      'что можно сделать',
      'блюдо',
    ];
    return keywords.any((keyword) => text.toLowerCase().contains(keyword));
  }

  bool _isIngredientQuery(String text) {
    final keywords = [
      'есть',
      'имеется',
      'продукты',
      'ингредиенты',
      'что нужно',
    ];
    return keywords.any((keyword) => text.toLowerCase().contains(keyword));
  }

  bool _isStepQuery(String text) {
    final keywords = [
      'следующий шаг',
      'дальше',
      'что потом',
      'повтори',
      'объясни',
    ];
    return keywords.any((keyword) => text.toLowerCase().contains(keyword));
  }

  Future<void> _handleRecipeQuery(String query) async {
    // Извлекаем ингредиенты из запроса
    final ingredients = _extractIngredients(query);
    await _aiProvider.suggestRecipes(ingredients);
    
    // Озвучиваем ответ
    if (_aiProvider.currentResponse != null) {
      await speak(_aiProvider.currentResponse!);
    }
  }

  Future<void> _handleIngredientQuery(String query) async {
    await _aiProvider.askAboutIngredients();
    
    // Озвучиваем вопрос о продуктах
    if (_aiProvider.currentResponse != null) {
      await speak(_aiProvider.currentResponse!);
    }
  }

  Future<void> _handleStepQuery(String query) async {
    // Если это запрос на объяснение шага
    if (query.contains('объясни')) {
      final step = _aiProvider.conversationHistory.last['content'] ?? '';
      await _aiProvider.explainCookingStep(step);
    }
    
    // Озвучиваем объяснение
    if (_aiProvider.currentResponse != null) {
      await speak(_aiProvider.currentResponse!);
    }
  }

  List<String> _extractIngredients(String query) {
    // Простой алгоритм извлечения ингредиентов из текста
    final words = query.toLowerCase().split(' ');
    final ingredients = <String>[];
    
    for (var i = 0; i < words.length; i++) {
      if (words[i] == 'из' && i + 1 < words.length) {
        ingredients.add(words[i + 1]);
      } else if (words[i] == 'и' && i + 1 < words.length && ingredients.isNotEmpty) {
        ingredients.add(words[i + 1]);
      }
    }
    
    return ingredients;
  }

  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
