import '../models/recipe_model.dart';

abstract class RecipeRepository {
  Future<List<RecipeModel>> getRecipes({
    String? query,
    List<String>? categories,
    List<String>? dietaryTags,
    String? authorId,
    int? limit,
  });

  Future<RecipeModel?> getRecipeById(String id);
  
  Future<List<RecipeModel>> getRecommendedRecipes({
    required String userId,
    required List<String> preferences,
    int limit = 10,
  });

  Future<List<RecipeModel>> searchRecipesByIngredients(
    List<String> ingredients,
  );

  Future<String> createRecipe(RecipeModel recipe);
  
  Future<void> updateRecipe(RecipeModel recipe);
  
  Future<void> deleteRecipe(String id);
  
  Future<void> rateRecipe(String recipeId, String userId, double rating);
  
  Future<List<String>> getCategories();
  
  Future<List<String>> getDietaryTags();
}
