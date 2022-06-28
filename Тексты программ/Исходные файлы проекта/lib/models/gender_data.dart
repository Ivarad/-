// Класс модели пола
class GenderData {
  int? id;
  String? gender;
// Инициализация переменных класса
  GenderData({this.id, this.gender});
// Функция которая передает переменным класса значения из json
  factory GenderData.fromJSON(Map<String, dynamic> parsedJson) {
    return GenderData(
      id: parsedJson['idGender'],
      gender: parsedJson['gender1'],
    );
  }
}
