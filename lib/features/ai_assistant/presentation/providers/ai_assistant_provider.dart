import 'package:flutter/foundation.dart';
import '../../domain/services/gpt_service.dart';
import '../../../profile/domain/models/user_preferences.dart';

class AIAssistantProvider with ChangeNotifier {
  final GPTService _gptService;
  bool _isLoading = false;
  String? _lastError;
  String? _currentResponse;
  List<Map<String, String>> _conversationHistory = [];

  AIAssistantProvider(this._gptService);

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  String? get currentResponse => _currentResponse;
  List<Map<String, String>> get conversationHistory => _conversationHistory;

  Future<void> introduceUser(List<UserPreferences> preferences) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      final prompt = '''
      Привет! Я новый пользователь приложения Culinario. Вот мои предпочтения:
      ${preferences.map((p) => '- ${p.toString()}').join('\n')}
      
      Пожалуйста, представься и расскажи, как ты можешь помочь мне с готовкой.
      ''';

      final response = await _gptService.generateResponse(prompt);
      _currentResponse = response.text;
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response.text,
      });
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> askAboutIngredients() async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      final prompt = '''
      Какие продукты у вас есть дома? Перечислите их, и я предложу рецепты, 
      которые можно приготовить из этих ингредиентов, учитывая ваши предпочтения.
      ''';

      final response = await _gptService.generateResponse(prompt);
      _currentResponse = response.text;
      _conversationHistory.add({
        'role': 'assistant',
        'content': prompt,
      });
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> suggestRecipes(List<String> ingredients) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      final prompt = '''
      У меня есть следующие ингредиенты:
      ${ingredients.join(', ')}

      Предложи рецепты, которые можно приготовить из них, учитывая мои предпочтения.
      Для каждого рецепта укажи:
      1. Название
      2. Время приготовления
      3. Сложность
      4. Пошаговые инструкции
      5. Советы по приготовлению
      ''';

      final response = await _gptService.generateResponse(prompt);
      _currentResponse = response.text;
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response.text,
      });
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> suggestRecipesBasedOnIngredients(List<String> ingredients) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      final prompt = '''На основе следующих ингредиентов, предложите 3 возможных рецепта:
${ingredients.join(', ')}
Для каждого рецепта укажите:
1. Название
2. Краткое описание
3. Дополнительные ингредиенты, которые могут понадобиться
4. Примерное время приготовления''';

      final response = await _gptService.getCompletion(prompt);
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> explainCookingStep(String step) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      final prompt = '''
      Объясни подробнее этот шаг приготовления:
      "$step"

      Расскажи:
      1. Какие тонкости нужно учесть
      2. На что обратить внимание
      3. Как понять, что всё сделано правильно
      4. Каких ошибок следует избегать
      ''';

      final response = await _gptService.generateResponse(prompt);
      _currentResponse = response.text;
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response.text,
      });
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
