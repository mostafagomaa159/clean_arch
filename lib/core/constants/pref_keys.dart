class PrefKeys {
  PrefKeys._();

  static const String isFirstTime = 'is_first_time';
  static const String isLoggedIn = 'is_logged_in';
  static const String languageCode = 'language_code';

  static const String email = 'email';
  static const String phone = 'phone';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String gender = 'gender';
  static const String birthDate = 'birth_date';
  static const String hasPregnancy = 'has_pregnancy';
  static const String chronicDisease = 'chronic_disease';
  static const String diseaseType = 'disease_type';

  static const String recentSearches = 'recent_searches';

  static const String cartId = 'cart_id';

  static const String customerToken = 'customer_token';

  static const String cachedBrands = 'cached_brands';

  static String cachedRegions(String languageCode) =>
      'cached_regions_$languageCode';

  static const String savedAddresses = 'saved_addresses';
}
