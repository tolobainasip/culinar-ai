class UserPreferences {
  final String code;
  final String name;
  final String description;

  const UserPreferences({
    required this.code,
    required this.name,
    required this.description,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
    };
  }
}
