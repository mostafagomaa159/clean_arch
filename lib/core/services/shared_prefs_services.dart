import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsServices {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  List<String> getStringList(String key) {
    return _prefs?.getStringList(key) ?? const [];
  }

  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }
}
