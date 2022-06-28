import 'package:pppd_project/models/cabinets_data.dart';
import 'package:pppd_project/models/doctor_schedule_data.dart';
import 'package:pppd_project/models/employee_data.dart';

// Класс модели специальностей врачей
class MedicalSpecialityData {
  int? specialityId, employeeId;
  String? speciality;
  EmployeeData? employeeData;
  CabinetData? cabinetData;
  List<DoctorScheduleData>? doctorScheduleData;
// Инициализация переменных класса
  MedicalSpecialityData(
      {this.specialityId,
      this.employeeId,
      this.speciality,
      this.employeeData,
      this.cabinetData,
      this.doctorScheduleData});
// Функция которая передает переменным класса значения из json
  factory MedicalSpecialityData.fromJSON(Map<String, dynamic> parsedJson) {
    List<DoctorScheduleData> tempList = <DoctorScheduleData>[];
    if (parsedJson['doctorSchedules'] != null) {
      parsedJson['doctorSchedules'].forEach((v) {
        tempList.add(DoctorScheduleData.fromJSON(v));
      });
    }
    return MedicalSpecialityData(
        specialityId: parsedJson['idSpecialty'],
        employeeId: parsedJson['employeeId'],
        speciality: parsedJson['specialty'],
        employeeData: parsedJson['employee'] != null
            ? EmployeeData.fromJSON(parsedJson['employee'])
            : null,
        cabinetData: parsedJson['cabinet'] != null
            ? CabinetData.fromJSON(parsedJson['cabinet'])
            : null,
        doctorScheduleData:
            parsedJson['doctorSchedules'] != null ? tempList : null);
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idSpecialty'] = specialityId;
    data['employeeId'] = employeeId;
    data['specialty'] = speciality;
    if (employeeData != null) {
      data['employee'] = employeeData!.toJson();
    }
    if (cabinetData != null) {
      data['cabinet'] = cabinetData!.toJson();
    }
    if (doctorScheduleData != null) {
      data['doctorSchedules'] =
          doctorScheduleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
