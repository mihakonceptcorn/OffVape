import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static const _keyLanguage = 'language_code';
  static const _keyDailyLimit = 'daily_limit';

  static Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, code);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  static Future<void> setDailyLimit(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDailyLimit, value);
  }

  static Future<int> getDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDailyLimit) ?? 30;
  }
}