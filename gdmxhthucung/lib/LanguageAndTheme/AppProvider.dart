import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('vi');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  AppProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';
    final language = prefs.getString('language') ?? 'vi';

    _themeMode = _getThemeModeFromString(theme);
    _locale = Locale(language);
    notifyListeners();
  }

  ThemeMode _getThemeModeFromString(String theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'light';
    }
  }

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    _themeMode = _getThemeModeFromString(theme);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }

  String getCurrentTheme() {
    return _getStringFromThemeMode(_themeMode);
  }

  String getCurrentLanguage() {
    return _locale.languageCode;
  }
}