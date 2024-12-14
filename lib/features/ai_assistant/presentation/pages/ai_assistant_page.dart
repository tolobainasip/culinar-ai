import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_assistant_provider.dart';
import '../../../voice/presentation/providers/voice_provider.dart';
import '../../../voice/presentation/widgets/voice_control_button.dart';

class AIAssistantPage extends StatelessWidget {
  const AIAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ассистент'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<AIAssistantProvider>().clearHistory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AIAssistantProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (aiProvider.conversationHistory.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Задайте вопрос кулинарному ассистенту',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Что приготовить на ужин?',
                            'Как приготовить пасту карбонара?',
                            'Что можно приготовить из курицы?',
                            'Посоветуй рецепт десерта',
                          ].map((suggestion) {
                            return SuggestionChip(
                              text: suggestion,
                              onTap: () => context.read<AIAssistantProvider>().getRecipeRecommendation(suggestion),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: aiProvider.conversationHistory.length,
                  itemBuilder: (context, index) {
                    final message = aiProvider.conversationHistory[index];
                    final isUser = message['role'] == 'user';

                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['content']!,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Consumer<VoiceProvider>(
                        builder: (context, voiceProvider, child) {
                          return Text(
                            voiceProvider.isListening
                                ? 'Говорите...'
                                : voiceProvider.lastRecognizedWords.isEmpty
                                    ? 'Нажмите и удерживайте для записи'
                                    : voiceProvider.lastRecognizedWords,
                            style: TextStyle(
                              color: voiceProvider.isListening
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const VoiceControlButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
