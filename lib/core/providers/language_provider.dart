import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/profile/domain/models/user_preferences.dart';

class LanguageProvider with ChangeNotifier {
  late UserPreferences _currentLanguage = UserPreferences(
    code: 'en',
    name: 'English',
    description: 'English language'
  );

  UserPreferences get currentLanguage => _currentLanguage;

  Future<void> setLanguage(UserPreferences language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', language.code);
    await prefs.setString('language_name', language.name);
    await prefs.setString('language_description', language.description);
    notifyListeners();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code') ?? 'en';
    final name = prefs.getString('language_name') ?? 'English';
    final description = prefs.getString('language_description') ?? 'English language';
    
    _currentLanguage = UserPreferences(
      code: code,
      name: name,
      description: description
    );
    notifyListeners();
  }
}
