import 'package:dart_openai/dart_openai.dart';

abstract class AIService {
  Future<String> generateRecipeRecommendations({
    required List<String> ingredients,
    required List<String> dietaryRestrictions,
    required String difficulty,
  });

  Future<String> answerCulinaryQuestion(String question);
  
  Future<List<String>> suggestIngredientSubstitutes(String ingredient);
}

class OpenAIService implements AIService {
  final OpenAI _openAI;
  
  OpenAIService(String apiKey) : _openAI = OpenAI.instance..apiKey = apiKey;

  @override
  Future<String> generateRecipeRecommendations({
    required List<String> ingredients,
    required List<String> dietaryRestrictions,
    required String difficulty,
  }) async {
    final prompt = '''
    Создай рецепт блюда используя следующие ингредиенты: ${ingredients.join(', ')}.
    Учитывай диетические ограничения: ${dietaryRestrictions.join(', ')}.
    Уровень сложности: $difficulty.
    
    Формат ответа должен включать:
    - Название блюда
    - Время приготовления
    - Список ингредиентов с количеством
    - Пошаговые инструкции
    - Пищевая ценность
    ''';

    final response = await _openAI.completion.create(
      model: 'gpt-3.5-turbo',
      prompt: prompt,
      maxTokens: 1000,
    );

    return response.choices.first.text;
  }

  @override
  Future<String> answerCulinaryQuestion(String question) async {
    final response = await _openAI.completion.create(
      model: 'gpt-3.5-turbo',
      prompt: 'Ответь на кулинарный вопрос: $question',
      maxTokens: 500,
    );

    return response.choices.first.text;
  }

  @override
  Future<List<String>> suggestIngredientSubstitutes(String ingredient) async {
    final response = await _openAI.completion.create(
      model: 'gpt-3.5-turbo',
      prompt: 'Предложи 3-5 альтернативных ингредиентов для замены: $ingredient',
      maxTokens: 200,
    );

    return response.choices.first.text
        .split('\n')
        .where((line) => line.isNotEmpty)
        .toList();
  }
}
