import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // Пользовательские настройки
  bool _isDarkMode = false;
  String _selectedLanguage = 'ru';
  List<String> _dietaryPreferences = [];
  
  // Геттеры
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  List<String> get dietaryPreferences => _dietaryPreferences;
  
  // Методы изменения состояния
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
  
  void updateDietaryPreferences(List<String> preferences) {
    _dietaryPreferences = preferences;
    notifyListeners();
  }
}
