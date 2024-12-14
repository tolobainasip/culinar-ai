import 'package:flutter/foundation.dart';
import '../../domain/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository;
  
  List<RecipeModel> _recipes = [];
  List<RecipeModel> _recommendedRecipes = [];
  List<String> _categories = [];
  List<String> _dietaryTags = [];
  bool _isLoading = false;
  String? _error;

  RecipeProvider(this._repository) {
    _initializeData();
  }

  // Геттеры
  List<RecipeModel> get recipes => _recipes;
  List<RecipeModel> get recommendedRecipes => _recommendedRecipes;
  List<String> get categories => _categories;
  List<String> get dietaryTags => _dietaryTags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
      _dietaryTags = await _repository.getDietaryTags();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecipes({
    String? query,
    List<String>? categories,
    List<String>? dietaryTags,
    String? authorId,
    int? limit,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _repository.getRecipes(
        query: query,
        categories: categories,
        dietaryTags: dietaryTags,
        authorId: authorId,
        limit: limit,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecommendedRecipes(String userId, List<String> preferences) async {
    try {
      _recommendedRecipes = await _repository.getRecommendedRecipes(
        userId: userId,
        preferences: preferences,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<List<RecipeModel>> searchByIngredients(List<String> ingredients) async {
    try {
      return await _repository.searchRecipesByIngredients(ingredients);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  Future<RecipeModel?> getRecipeById(String id) async {
    try {
      return await _repository.getRecipeById(id);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  Future<String?> createRecipe(RecipeModel recipe) async {
    try {
      final id = await _repository.createRecipe(recipe);
      await loadRecipes(); // Обновляем список рецептов
      return id;
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  Future<bool> updateRecipe(RecipeModel recipe) async {
    try {
      await _repository.updateRecipe(recipe);
      await loadRecipes(); // Обновляем список рецептов
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteRecipe(String id) async {
    try {
      await _repository.deleteRecipe(id);
      await loadRecipes(); // Обновляем список рецептов
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> rateRecipe(String recipeId, String userId, double rating) async {
    try {
      await _repository.rateRecipe(recipeId, userId, rating);
      await loadRecipes(); // Обновляем список рецептов
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
