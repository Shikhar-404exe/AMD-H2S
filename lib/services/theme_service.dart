import 'package:flutter/material.dart';
import 'storage_service.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final StorageService _storage = StorageService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> init() async {
    _isDarkMode = await _storage.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _storage.setBool('dark_mode', _isDarkMode);
      notifyListeners();
    }
  }
}
