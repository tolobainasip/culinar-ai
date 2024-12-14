import 'package:flutter/foundation.dart';
import '../../domain/services/ai_service.dart';

class AIProvider with ChangeNotifier {
  final AIService _aiService;
  bool _isLoading = false;
  String? _lastError;
  String? _currentRecipe;

  AIProvider(this._aiService);

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  String? get currentRecipe => _currentRecipe;

  Future<void> generateRecipe({
    required List<String> ingredients,
    required List<String> dietaryRestrictions,
    required String difficulty,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      _currentRecipe = await _aiService.generateRecipeRecommendations(
        ingredients: ingredients,
        dietaryRestrictions: dietaryRestrictions,
        difficulty: difficulty,
      );
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> askCulinaryQuestion(String question) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      return await _aiService.answerCulinaryQuestion(question);
    } catch (e) {
      _lastError = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> getIngredientSubstitutes(String ingredient) async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      return await _aiService.suggestIngredientSubstitutes(ingredient);
    } catch (e) {
      _lastError = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
