import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/ai_assistant/data/services/openai_gpt_service.dart';
import '../features/ai_assistant/presentation/providers/ai_assistant_provider.dart';
import '../features/auth/data/repositories/firebase_auth_repository.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'providers/language_provider.dart';
import 'theme/app_theme.dart';

class CulinarioApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const CulinarioApp({
    super.key,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => FirebaseAuthRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(sharedPreferences),
        ),
        ProxyProvider<LanguageProvider, OpenAIGPTService>(
          update: (context, languageProvider, previous) =>
              OpenAIGPTService(languageProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<FirebaseAuthRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AIAssistantProvider(
            context.read<OpenAIGPTService>(),
          ),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Culinario',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: Locale(languageProvider.currentLanguage.code),
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return authProvider.isAuthenticated
                    ? const HomePage()
                    : const LoginPage();
              },
            ),
            localizationsDelegates: const [
              // GlobalMaterialLocalizations.delegate,
              // GlobalWidgetsLocalizations.delegate,
              // GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', ''),
              Locale('ky', ''),
              Locale('kk', ''),
            ],
          );
        },
      ),
    );
  }
}
