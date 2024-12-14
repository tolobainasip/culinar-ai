import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ai_assistant/presentation/providers/ai_assistant_provider.dart';
import '../../../profile/domain/models/user_preferences.dart';

class AIIntroductionPage extends StatefulWidget {
  const AIIntroductionPage({super.key});

  @override
  State<AIIntroductionPage> createState() => _AIIntroductionPageState();
}

class _AIIntroductionPageState extends State<AIIntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<UserPreferences> _preferences = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Как вас зовут?',
      'type': 'text',
      'icon': Icons.person,
    },
    {
      'question': 'Есть ли у вас диетические ограничения?',
      'type': 'multiple',
      'icon': Icons.restaurant,
      'options': [
        'Вегетарианство',
        'Веганство',
        'Безглютеновая диета',
        'Без лактозы',
        'Нет ограничений',
      ],
    },
    {
      'question': 'Какую кухню вы предпочитаете?',
      'type': 'multiple',
      'icon': Icons.public,
      'options': [
        'Итальянская',
        'Азиатская',
        'Русская',
        'Французская',
        'Мексиканская',
      ],
    },
    {
      'question': 'Сколько времени вы готовы тратить на готовку?',
      'type': 'single',
      'icon': Icons.timer,
      'options': [
        '15-30 минут',
        '30-60 минут',
        'Более часа',
      ],
    },
  ];

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final aiProvider = context.read<AIAssistantProvider>();
    
    // Инициализируем диалог с AI
    await aiProvider.introduceUser(_preferences);
    
    if (!mounted) return;
    
    // Переходим на главный экран
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentPage + 1) / _questions.length,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final question = _questions[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          question['icon'] as IconData,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          question['question'],
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        _buildQuestionWidget(question),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Назад'),
                    )
                  else
                    const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _questions.length - 1
                          ? 'Завершить'
                          : 'Далее',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    switch (question['type']) {
      case 'text':
        return TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Введите ваше имя',
          ),
          onChanged: (value) {
            // Сохраняем имя пользователя
          },
        );
      case 'multiple':
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (question['options'] as List<String>).map((option) {
            return FilterChip(
              label: Text(option),
              selected: false,
              onSelected: (selected) {
                // Сохраняем выбранные опции
              },
            );
          }).toList(),
        );
      case 'single':
        return Column(
          children: (question['options'] as List<String>).map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: null,
              onChanged: (value) {
                // Сохраняем выбранную опцию
              },
            );
          }).toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
