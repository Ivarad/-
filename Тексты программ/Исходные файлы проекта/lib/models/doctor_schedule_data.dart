// Класс модели расписания врачей
class DoctorScheduleData {
  int? scheduleId, specialityId;

// Инициализация переменных класса
  DoctorScheduleData({
    this.scheduleId,
    this.specialityId,
  });
// Функция которая передает переменным класса значения из json
  factory DoctorScheduleData.fromJSON(Map<String, dynamic> parsedJson) {
    return DoctorScheduleData(
      scheduleId: parsedJson['scheduleId'],
      specialityId: parsedJson['specialityId'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheduleId'] = scheduleId;
    data['specialityId'] = specialityId;
    return data;
  }
}
