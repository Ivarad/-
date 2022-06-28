import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/theme_preference.dart';

// Класс определяющий модели темы приложения
class ThemeModel extends ChangeNotifier {
  late bool _isDark; // Приватная переменная определяющая состяиние темной темы
  late ThemePreferences
      _preferences; // Пременнная с экзепляром класса сохранения и получения данных о теме приложения
  bool get isDark => _isDark; // Внесение значения в перменную состояния темы
  // Инициализация знасений в данном классе
  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }
  // Установка темной темы
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  // Метод получения сохраненных данных о теме
  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
