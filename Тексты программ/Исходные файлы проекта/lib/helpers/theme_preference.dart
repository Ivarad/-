import 'package:shared_preferences/shared_preferences.dart';

// Класс определяющий тему приложения
class ThemePreferences {
  static const PREF_KEY = "pref_key"; // ключ активной темы

// Метод сохранения состояния текущей темы
  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREF_KEY, value);
  }

// Функция получающая состояние текущей темы
  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_KEY) ?? false;
  }
}
