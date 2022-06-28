// Класс модели даты первичного обращения
class DateFirstAppealData {
  int? id;
  String? dateFirstAppeal;
// Инициализация переменных класса
  DateFirstAppealData({
    this.id,
    this.dateFirstAppeal,
  });
// Функция которая передает переменным класса значения из json
  factory DateFirstAppealData.fromJSON(Map<String, dynamic> parsedJson) {
    return DateFirstAppealData(
      id: parsedJson['idDateFirstRendered'],
      dateFirstAppeal: parsedJson['dateFirstRenered'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    return {
      'idDateFirstRendered': id,
      'dateFirstRenered': dateFirstAppeal,
    };
  }
}
