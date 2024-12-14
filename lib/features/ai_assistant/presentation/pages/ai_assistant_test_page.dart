import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_languages.dart';
import '../../../../core/providers/language_provider.dart';
import '../providers/ai_assistant_provider.dart';

class AIAssistantTestPage extends StatefulWidget {
  const AIAssistantTestPage({super.key});

  @override
  State<AIAssistantTestPage> createState() => _AIAssistantTestPageState();
}

class _AIAssistantTestPageState extends State<AIAssistantTestPage> {
  final _testQueries = {
    'ru': [
      'Что можно приготовить из курицы и брокколи?',
      'Подскажи рецепт простого десерта',
      'Как правильно варить рис?',
    ],
    'ky': [
      'Тооктун эти менен брокколиден эмне жасаса болот?',
      'Жөнөкөй десерттин рецептин айтып бериңиз',
      'Күрүчтү кандай туура бышыруу керек?',
    ],
    'kk': [
      'Тауық еті мен брокколиден не пісіруге болады?',
      'Қарапайым десерттің рецептін айтып беріңізші',
      'Күрішті қалай дұрыс пісіру керек?',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ассистент - Тест'),
      ),
      body: Column(
        children: [
          // Селектор языка
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Язык: '),
                const SizedBox(width: 16),
                ...AppLanguage.values.map(
                  (lang) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(lang.name),
                      selected: context.watch<LanguageProvider>().currentLanguage == lang,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<LanguageProvider>().setLanguage(lang);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Тестовые запросы
          Expanded(
            child: Consumer2<LanguageProvider, AIAssistantProvider>(
              builder: (context, langProvider, aiProvider, child) {
                final queries = _testQueries[langProvider.currentLanguage.code] ?? [];
                
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final query in queries) ...[
                      Card(
                        child: ListTile(
                          title: Text(query),
                          onTap: () async {
                            final response = await aiProvider.getRecipeRecommendation(query);
                            if (!mounted) return;
                            
                            if (response != null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Ответ AI'),
                                  content: SingleChildScrollView(
                                    child: Text(response.text),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Закрыть'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                );
              },
            ),
          ),

          // Статус и ошибки
          Consumer<AIAssistantProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }
              if (provider.error != null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Ошибка: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
