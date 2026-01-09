import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPrefService? _instance;
  static SharedPreferences? _preferences;

  SharedPrefService._internal();

  // Singleton instance getter
  static Future<SharedPrefService> get instance async {
    _instance ??= SharedPrefService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  String? getString(String key, {String? defaultValue}) {
    return _preferences!.getString(key) ?? defaultValue;
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  int? getInt(String key, {int? defaultValue}) {
    return _preferences!.getInt(key) ?? defaultValue;
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  double? getDouble(String key, {double? defaultValue}) {
    return _preferences!.getDouble(key) ?? defaultValue;
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  bool? getBool(String key, {bool? defaultValue}) {
    return _preferences!.getBool(key) ?? defaultValue;
  }

  // StringList operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences!.setStringList(key, value);
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return _preferences!.getStringList(key) ?? defaultValue;
  }

  // Remove a key
  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return await _preferences!.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _preferences!.getKeys();
  }
}
