import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/providers/language_provider.dart';
import '../../domain/models/ai_response_model.dart';
import '../../domain/services/gpt_service.dart';

class OpenAIGPTService implements GPTService {
  final OpenAI _openAI;
  final LanguageProvider _languageProvider;

  OpenAIGPTService(this._languageProvider) : _openAI = OpenAI.instance;

  @override
  Future<AIResponseModel> generateRecipeRecommendation(String query) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Messages(
            role: Role.system,
            content: _languageProvider.getSystemPrompt(),
          ),
          Messages(
            role: Role.user,
            content: query,
          ),
        ],
        model: GptTurbo0631Model(),
        maxToken: 1000,
      );

      final response = await _openAI.onChatCompletion(request: request);
      final content = response?.choices.first.message?.content ?? '';

      return AIResponseModel(
        text: content,
        metadata: {
          'query': query,
          'type': 'recipe_recommendation',
          'language': _languageProvider.currentLanguage.code,
        },
      );
    } catch (e) {
      throw Exception('Ошибка при генерации рекомендации: $e');
    }
  }

  @override
  Future<AIResponseModel> analyzeIngredients(List<String> ingredients) async {
    try {
      final ingredientsText = ingredients.join(', ');
      final request = ChatCompleteText(
        messages: [
          Messages(
            role: Role.system,
            content: _languageProvider.getIngredientPrompt(),
          ),
          Messages(
            role: Role.user,
            content: 'Что можно приготовить из следующих ингредиентов: $ingredientsText?',
          ),
        ],
        model: GptTurbo0631Model(),
        maxToken: 1000,
      );

      final response = await _openAI.onChatCompletion(request: request);
      final content = response?.choices.first.message?.content ?? '';

      return AIResponseModel(
        text: content,
        metadata: {
          'ingredients': ingredients,
          'type': 'ingredient_analysis',
          'language': _languageProvider.currentLanguage.code,
        },
      );
    } catch (e) {
      throw Exception('Ошибка при анализе ингредиентов: $e');
    }
  }

  @override
  Future<AIResponseModel> getCookingTips(String question) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Messages(
            role: Role.system,
            content: _languageProvider.getCookingTipsPrompt(),
          ),
          Messages(
            role: Role.user,
            content: question,
          ),
        ],
        model: GptTurbo0631Model(),
        maxToken: 1000,
      );

      final response = await _openAI.onChatCompletion(request: request);
      final content = response?.choices.first.message?.content ?? '';

      return AIResponseModel(
        text: content,
        metadata: {
          'question': question,
          'type': 'cooking_tip',
          'language': _languageProvider.currentLanguage.code,
        },
      );
    } catch (e) {
      throw Exception('Ошибка при получении совета: $e');
    }
  }
}
