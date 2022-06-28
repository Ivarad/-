// Класс модели сотрудников
class EmployeeData {
  int? id, postId, accountId;
  String? name, surname, patronymic;
  String? dateOfBirth;
// Инициализация переменных класса
  EmployeeData({
    this.id,
    this.postId,
    this.accountId,
    this.name,
    this.surname,
    this.patronymic,
    this.dateOfBirth,
  });
// Функция которая передает переменным класса значения из json
  factory EmployeeData.fromJSON(Map<String, dynamic> parsedJson) {
    return EmployeeData(
      id: parsedJson['idEmployee'],
      postId: parsedJson['postId'],
      name: parsedJson['name'],
      patronymic: parsedJson['patronymic'],
      surname: parsedJson['surname'],
      dateOfBirth: parsedJson['dateOfBirth'],
      accountId: parsedJson['accountId'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEmployee'] = id;
    data['postId'] = postId;
    data['name'] = name;
    data['patronymic'] = patronymic;
    data['surname'] = surname;
    data['dateOfBirth'] = dateOfBirth;
    data['accountId'] = accountId;
    return data;
  }
}
