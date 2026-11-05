class AppStores {
  const AppStores._();

  static const String header = 'store';

  static const String arabic = 'arabic';

  static const String defaultView = 'default';

  static String forLanguage(String languageCode) =>
      languageCode == arabicLanguageCode ? arabic : defaultView;

  static const String arabicLanguageCode = 'ar';
  static const String englishLanguageCode = 'en';
}
