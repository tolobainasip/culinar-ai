import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../../domain/models/ai_response_model.dart';

abstract class GPTService {
  Future<String> generateResponse(String prompt);
  Future<String> generateRecipeRecommendation(String query);
  Future<String> generateCookingInstructions(String recipe);
}
