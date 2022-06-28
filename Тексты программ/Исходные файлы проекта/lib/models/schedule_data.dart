import 'package:pppd_project/models/doctor_schedule_data.dart';

// Класс модели расписания
class ScheduleData {
  int? id;
  String? time;
  List<DoctorScheduleData>? doctorScheduleData;
// Инициализация переменных класса
  ScheduleData({this.id, this.time, this.doctorScheduleData});
// Функция которая передает переменным класса значения из json
  factory ScheduleData.fromJSON(Map<String, dynamic> parsedJson) {
    List<DoctorScheduleData> tempList = <DoctorScheduleData>[];
    if (parsedJson['doctorSchedules'] != null) {
      parsedJson['doctorSchedules'].forEach((v) {
        tempList.add(DoctorScheduleData.fromJSON(v));
      });
    }
    return ScheduleData(
        id: parsedJson['idSchedule'],
        time: parsedJson['time'],
        doctorScheduleData:
            parsedJson['doctorSchedules'] != null ? tempList : null);
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idSchedule'] = id;
    data['time'] = time;
    if (doctorScheduleData != null) {
      data['doctorSchedules'] =
          doctorScheduleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
