import 'package:shared_preferences/shared_preferences.dart';

// Класс определяющий авторизованного пользователя
class Authorizated {
  static const authKey = "auth_key"; // ключ авторизации

  // Метод записи данных об авторизованном пользователе
  setAuthorizated(bool value, int id, int roleId, String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('id', id);
    sharedPreferences.setInt('roleId', roleId);
    sharedPreferences.setString('email', email);
    sharedPreferences.setBool(authKey, value);
  }

  // Функция получения записанных данных об авторизованном пользователе
  Future<List<String>> getAuthorizated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> authData = [
      sharedPreferences.getBool(authKey).toString(),
      sharedPreferences.getInt('id').toString(),
      sharedPreferences.getInt('roleId').toString(),
      sharedPreferences.getString('email').toString()
    ];
    return authData;
  }

  // Метод удаления данных авторизованного пользователя
  deleteKeys() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('id');
    sharedPreferences.remove('roleId');
    sharedPreferences.remove('email');
    sharedPreferences.remove(authKey);
  }
}
