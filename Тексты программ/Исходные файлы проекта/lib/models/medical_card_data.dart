// Класс модели медкарт
class MedicalCardData {
  int? id;
  String? dateOfCompletion, dateOfBirth;
  String? name, surname, patronymic;
  int? genderId;
  int? chiPolicy, snils;
// Инициализация переменных класса
  MedicalCardData(
      {this.id,
      this.dateOfBirth,
      this.dateOfCompletion,
      this.name,
      this.surname,
      this.patronymic,
      this.genderId,
      this.chiPolicy,
      this.snils});
// Функция которая передает переменным класса значения из json
  factory MedicalCardData.fromJSON(Map<String, dynamic> parsedJson) {
    return MedicalCardData(
      id: parsedJson['idMedicalCard'],
      dateOfCompletion: parsedJson['dateOfCompletion'],
      surname: parsedJson['surname'],
      name: parsedJson['name'],
      patronymic: parsedJson['patronymic'],
      dateOfBirth: parsedJson['dateOfBirth'],
      genderId: parsedJson['genderId'],
      chiPolicy: parsedJson['chiPolicy'],
      snils: parsedJson['snils'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMedicalCard'] = id;
    data['dateOfCompletion'] = dateOfCompletion;
    data['surname'] = surname;
    data['name'] = name;
    data['patronymic'] = patronymic;
    data['dateOfBirth'] = dateOfBirth;
    data['genderId'] = genderId;
    data['chiPolicy'] = chiPolicy;
    data['snils'] = snils;
    return data;
  }
}
