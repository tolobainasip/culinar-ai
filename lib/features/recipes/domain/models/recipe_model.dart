class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final List<String> categories;
  final List<IngredientModel> ingredients;
  final List<StepModel> steps;
  final NutritionModel nutrition;
  final int cookingTimeMinutes;
  final int servings;
  final String difficulty;
  final List<String> dietaryTags;
  final String? imageUrl;
  final double rating;
  final int reviewsCount;
  final DateTime createdAt;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.categories,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
    required this.cookingTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.dietaryTags,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewsCount = 0,
    required this.createdAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      categories: List<String>.from(json['categories']),
      ingredients: (json['ingredients'] as List)
          .map((i) => IngredientModel.fromJson(i))
          .toList(),
      steps: (json['steps'] as List)
          .map((s) => StepModel.fromJson(s))
          .toList(),
      nutrition: NutritionModel.fromJson(json['nutrition']),
      cookingTimeMinutes: json['cookingTimeMinutes'] as int,
      servings: json['servings'] as int,
      difficulty: json['difficulty'] as String,
      dietaryTags: List<String>.from(json['dietaryTags']),
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'categories': categories,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps.map((s) => s.toJson()).toList(),
      'nutrition': nutrition.toJson(),
      'cookingTimeMinutes': cookingTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'dietaryTags': dietaryTags,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class IngredientModel {
  final String name;
  final double amount;
  final String unit;
  final String? notes;

  IngredientModel({
    required this.name,
    required this.amount,
    required this.unit,
    this.notes,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
      'notes': notes,
    };
  }
}

class StepModel {
  final int order;
  final String description;
  final String? imageUrl;
  final int? timerSeconds;

  StepModel({
    required this.order,
    required this.description,
    this.imageUrl,
    this.timerSeconds,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      order: json['order'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      timerSeconds: json['timerSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'description': description,
      'imageUrl': imageUrl,
      'timerSeconds': timerSeconds,
    };
  }
}

class NutritionModel {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double? fiber;
  final double? sugar;

  NutritionModel({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    this.fiber,
    this.sugar,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: json['fiber'] != null ? (json['fiber'] as num).toDouble() : null,
      sugar: json['sugar'] != null ? (json['sugar'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
    };
  }
}
