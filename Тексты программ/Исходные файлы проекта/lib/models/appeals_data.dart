import 'package:pppd_project/models/budget_types_data.dart';
import 'package:pppd_project/models/cabinets_data.dart';
import 'package:pppd_project/models/dates_first_appeal_data.dart';
import 'package:pppd_project/models/employee_data.dart';
import 'package:pppd_project/models/medical_card_data.dart';
import 'package:pppd_project/models/medical_speciality_data.dart';
import 'package:pppd_project/models/patient_data.dart';
import 'package:pppd_project/models/schedule_data.dart';

// Класс модели обращения
class AppealData {
  int? id;
  int? dateFirstRenderedId, scheduleId, patientId, employeeId, bugetTypeId;
  String? dateOfRendering;
  String? complaints, inspection, diagnosis, recommendations;
  bool? closed;
  DateFirstAppealData? dateFirstAppealData;
  PatientData? patientData;
  EmployeeData? employeeData;
  ScheduleData? scheduleData;
  BudgetTypeData? budgetTypeData;
  MedicalSpecialityData? medicalSpecialityData;
  MedicalCardData? medicalCardData;
  CabinetData? cabinetData;
// Инициализация переменных класса
  AppealData(
      {this.id,
      this.dateFirstRenderedId,
      this.scheduleId,
      this.patientId,
      this.employeeId,
      this.bugetTypeId,
      this.dateOfRendering,
      this.complaints,
      this.inspection,
      this.diagnosis,
      this.recommendations,
      this.closed,
      this.dateFirstAppealData,
      this.patientData,
      this.employeeData,
      this.scheduleData,
      this.budgetTypeData,
      this.medicalSpecialityData,
      this.medicalCardData,
      this.cabinetData});

// Функция которая передает переменным класса значения из json
  factory AppealData.fromJSON(Map<String, dynamic> parsedJson) {
    return AppealData(
      id: parsedJson['idServicesRendered'],
      dateFirstRenderedId: parsedJson['dateFirstRenderedId'],
      dateOfRendering: parsedJson['dateOfRendering'],
      bugetTypeId: parsedJson['budgetTypeId'],
      patientId: parsedJson['patientId'],
      employeeId: parsedJson['employeeId'],
      complaints: parsedJson['complaints'],
      inspection: parsedJson['inspection'],
      diagnosis: parsedJson['diagnosis'],
      recommendations: parsedJson['recommendations'],
      scheduleId: parsedJson['scheduleId'],
      closed: parsedJson['closed'],
      budgetTypeData: parsedJson['budgetType'] != null
          ? BudgetTypeData.fromJSON(parsedJson['budgetType'])
          : null,
      dateFirstAppealData: parsedJson['datesFirstRendered'] != null
          ? DateFirstAppealData.fromJSON(parsedJson['datesFirstRendered'])
          : null,
      patientData: parsedJson['patient'] != null
          ? PatientData.fromJSON(parsedJson['patient'])
          : null,
      employeeData: parsedJson['employee'] != null
          ? EmployeeData.fromJSON(parsedJson['employee'])
          : null,
      scheduleData: parsedJson['schedule'] != null
          ? ScheduleData.fromJSON(parsedJson['schedule'])
          : null,
      medicalSpecialityData: parsedJson['medicalSpecialty'] != null
          ? MedicalSpecialityData.fromJSON(parsedJson['medicalSpecialty'])
          : null,
      medicalCardData: parsedJson['medicalCard'] != null
          ? MedicalCardData.fromJSON(parsedJson['medicalCard'])
          : null,
      cabinetData: parsedJson['cabinet'] != null
          ? CabinetData.fromJSON(parsedJson['cabinet'])
          : null,
    );
  }

// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idServicesRendered'] = id;
    data['dateFirstRenderedId'] = dateFirstRenderedId;
    data['dateOfRendering'] = dateOfRendering;
    data['budgetTypeId'] = bugetTypeId;
    data['patientId'] = patientId;
    data['employeeId'] = employeeId;
    data['complaints'] = complaints;
    data['inspection'] = inspection;
    data['diagnosis'] = diagnosis;
    data['recommendations'] = recommendations;
    data['scheduleId'] = scheduleId;
    data['closed'] = closed;
    return data;
  }
}
