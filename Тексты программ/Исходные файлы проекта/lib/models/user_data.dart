// Класс модели данных пользователя
class UserData {
  int? id;
  String? login, password, email;
  int? roleId;
// Инициализация переменных класса
  UserData({this.id, this.login, this.password, this.email, this.roleId});
// Функция которая передает переменным класса значения из json
  factory UserData.fromJSON(Map<String, dynamic> parsedJson) {
    return UserData(
      id: parsedJson['idAccount'],
      login: parsedJson['login'],
      password: parsedJson['password'],
      email: parsedJson['email'],
      roleId: parsedJson['roleId'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idAccount'] = id;
    data['login'] = login;
    data['password'] = password;
    data['email'] = email;
    data['roleId'] = roleId;
    return data;
  }
}
