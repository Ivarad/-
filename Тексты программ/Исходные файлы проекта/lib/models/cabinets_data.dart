// Класс модели кабинетов
class CabinetData {
  int? id, employeeId;
// Инициализация переменных класса
  CabinetData({
    this.id,
    this.employeeId,
  });
// Функция которая передает переменным класса значения из json
  factory CabinetData.fromJSON(Map<String, dynamic> parsedJson) {
    return CabinetData(
      id: parsedJson['idCabinet'],
      employeeId: parsedJson['employeeId'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idCabinet'] = id;
    data['employeeId'] = employeeId;
    return data;
  }
}
