import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_languages.dart';
import '../providers/language_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<AppLanguage>(
          icon: const Icon(Icons.language),
          onSelected: (AppLanguage language) {
            provider.setLanguage(language);
          },
          itemBuilder: (BuildContext context) {
            return AppLanguage.values.map((AppLanguage language) {
              return PopupMenuItem<AppLanguage>(
                value: language,
                child: Row(
                  children: [
                    if (provider.currentLanguage == language)
                      const Icon(Icons.check, size: 20)
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    Text(language.name),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
