import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';

class FirebaseRecipeRepository implements RecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RecipeModel>> getRecipes({
    String? query,
    List<String>? categories,
    List<String>? dietaryTags,
    String? authorId,
    int? limit,
  }) async {
    Query recipesQuery = _firestore.collection('recipes');

    if (authorId != null) {
      recipesQuery = recipesQuery.where('authorId', isEqualTo: authorId);
    }

    if (categories != null && categories.isNotEmpty) {
      recipesQuery = recipesQuery.where('categories', arrayContainsAny: categories);
    }

    if (dietaryTags != null && dietaryTags.isNotEmpty) {
      recipesQuery = recipesQuery.where('dietaryTags', arrayContainsAny: dietaryTags);
    }

    if (limit != null) {
      recipesQuery = recipesQuery.limit(limit);
    }

    final snapshot = await recipesQuery.get();
    final recipes = snapshot.docs
        .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    if (query != null && query.isNotEmpty) {
      return recipes.where((recipe) =>
          recipe.title.toLowerCase().contains(query.toLowerCase()) ||
          recipe.description.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return recipes;
  }

  @override
  Future<RecipeModel?> getRecipeById(String id) async {
    final doc = await _firestore.collection('recipes').doc(id).get();
    if (!doc.exists) return null;
    return RecipeModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<List<RecipeModel>> getRecommendedRecipes({
    required String userId,
    required List<String> preferences,
    int limit = 10,
  }) async {
    // В будущем здесь может быть более сложная логика рекомендаций
    final snapshot = await _firestore
        .collection('recipes')
        .where('dietaryTags', arrayContainsAny: preferences)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<RecipeModel>> searchRecipesByIngredients(
    List<String> ingredients,
  ) async {
    // Поиск рецептов, где есть хотя бы один из указанных ингредиентов
    final snapshot = await _firestore
        .collection('recipes')
        .where('ingredients.name', arrayContainsAny: ingredients)
        .get();

    return snapshot.docs
        .map((doc) => RecipeModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<String> createRecipe(RecipeModel recipe) async {
    final docRef = await _firestore.collection('recipes').add(recipe.toJson());
    return docRef.id;
  }

  @override
  Future<void> updateRecipe(RecipeModel recipe) async {
    await _firestore
        .collection('recipes')
        .doc(recipe.id)
        .update(recipe.toJson());
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await _firestore.collection('recipes').doc(id).delete();
  }

  @override
  Future<void> rateRecipe(String recipeId, String userId, double rating) async {
    final batch = _firestore.batch();
    
    // Добавляем оценку в коллекцию рейтингов
    final ratingRef = _firestore
        .collection('recipes')
        .doc(recipeId)
        .collection('ratings')
        .doc(userId);
    
    batch.set(ratingRef, {
      'rating': rating,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Обновляем средний рейтинг рецепта
    final recipeRef = _firestore.collection('recipes').doc(recipeId);
    final recipeDoc = await recipeRef.get();
    final currentRating = recipeDoc.data()?['rating'] ?? 0.0;
    final currentCount = recipeDoc.data()?['reviewsCount'] ?? 0;
    
    final newCount = currentCount + 1;
    final newRating = ((currentRating * currentCount) + rating) / newCount;
    
    batch.update(recipeRef, {
      'rating': newRating,
      'reviewsCount': newCount,
    });

    await batch.commit();
  }

  @override
  Future<List<String>> getCategories() async {
    final doc = await _firestore.collection('metadata').doc('categories').get();
    return List<String>.from(doc.data()?['list'] ?? []);
  }

  @override
  Future<List<String>> getDietaryTags() async {
    final doc = await _firestore.collection('metadata').doc('dietaryTags').get();
    return List<String>.from(doc.data()?['list'] ?? []);
  }
}
