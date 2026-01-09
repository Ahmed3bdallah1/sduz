import 'shared_pref_service.dart';

class LocalDatabaseService {
  static LocalDatabaseService? _instance;
  late SharedPrefService _sharedPrefService;

  LocalDatabaseService._internal();

  // Singleton instance getter
  static Future<LocalDatabaseService> get instance async {
    _instance ??= LocalDatabaseService._internal();
    _instance!._sharedPrefService = await SharedPrefService.instance;
    return _instance!;
  }

  // User data keys
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLanguage = 'app_language';
  static const String _keyTheme = 'app_theme';
  static const String _keyUserRole = 'user_role';

  // Auth Token
  Future<bool> saveToken(String token) async {
    return await _sharedPrefService.setString(_keyToken, token);
  }

  String? getToken() {
    return _sharedPrefService.getString(_keyToken);
  }

  Future<bool> clearToken() async {
    return await _sharedPrefService.remove(_keyToken);
  }

  // User ID
  Future<bool> saveUserId(String userId) async {
    return await _sharedPrefService.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return _sharedPrefService.getString(_keyUserId);
  }

  // User Email
  Future<bool> saveUserEmail(String email) async {
    return await _sharedPrefService.setString(_keyUserEmail, email);
  }

  String? getUserEmail() {
    return _sharedPrefService.getString(_keyUserEmail);
  }

  // Login Status
  Future<bool> setLoggedIn(bool isLoggedIn) async {
    return await _sharedPrefService.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _sharedPrefService.getBool(_keyIsLoggedIn, defaultValue: false) ?? false;
  }

  // Language
  Future<bool> saveLanguage(String languageCode) async {
    return await _sharedPrefService.setString(_keyLanguage, languageCode);
  }

  String? getLanguage() {
    return _sharedPrefService.getString(_keyLanguage);
  }

  // Theme
  Future<bool> saveTheme(String theme) async {
    return await _sharedPrefService.setString(_keyTheme, theme);
  }

  String? getTheme() {
    return _sharedPrefService.getString(_keyTheme);
  }

  // Logout - Clear user data
  Future<bool> logout() async {
    await _sharedPrefService.remove(_keyToken);
    await _sharedPrefService.remove(_keyUserId);
    await _sharedPrefService.remove(_keyUserEmail);
    return await _sharedPrefService.setBool(_keyIsLoggedIn, false);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _sharedPrefService.clear();
  }

  // Generic methods for custom data
  Future<bool> saveString(String key, String value) async {
    return await _sharedPrefService.setString(key, value);
  }

  String? loadString(String key, {String? defaultValue}) {
    return _sharedPrefService.getString(key, defaultValue: defaultValue);
  }

  Future<bool> saveInt(String key, int value) async {
    return await _sharedPrefService.setInt(key, value);
  }

  int? loadInt(String key, {int? defaultValue}) {
    return _sharedPrefService.getInt(key, defaultValue: defaultValue);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _sharedPrefService.setBool(key, value);
  }

  bool? loadBool(String key, {bool? defaultValue}) {
    return _sharedPrefService.getBool(key, defaultValue: defaultValue);
  }

  Future<bool> saveUserRole(String role) async {
    return await _sharedPrefService.setString(_keyUserRole, role);
  }

  String? getUserRole() {
    return _sharedPrefService.getString(_keyUserRole);
  }

  Future<bool> clearUserRole() async {
    return await _sharedPrefService.remove(_keyUserRole);
  }

  Future<bool> remove(String key) async {
    return await _sharedPrefService.remove(key);
  }

  bool containsKey(String key) {
    return _sharedPrefService.containsKey(key);
  }
}
