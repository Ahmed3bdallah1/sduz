class AppConstants {
  // API
  static const String baseUrl = 'http://sudz.magiccleanksa.com';
  static const String apiVersion = 'v1';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // SharedPreferences Keys
  static const String keyToken = 'token';
  static const String keyUserId = 'user_id';
  static const String keyLanguage = 'language';

  // Routes
  static const String initialRoute = '/';
}
