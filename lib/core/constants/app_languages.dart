enum AppLanguage {
  russian('ru', 'Русский'),
  kyrgyz('ky', 'Кыргызча'),
  kazakh('kk', 'Қазақша');

  final String code;
  final String name;

  const AppLanguage(this.code, this.name);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.russian,
    );
  }
}
