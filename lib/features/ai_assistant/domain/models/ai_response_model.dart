class AIResponseModel {
  final String text;
  final List<String>? recipeIds;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  AIResponseModel({
    required this.text,
    this.recipeIds,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory AIResponseModel.fromJson(Map<String, dynamic> json) {
    return AIResponseModel(
      text: json['text'] as String,
      recipeIds: json['recipeIds'] != null
          ? List<String>.from(json['recipeIds'] as List)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'recipeIds': recipeIds,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
