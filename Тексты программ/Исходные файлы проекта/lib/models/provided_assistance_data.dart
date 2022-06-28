import 'package:pppd_project/models/appeals_data.dart';
import 'package:pppd_project/models/incomes_and_expenses_data.dart';
import 'package:pppd_project/models/medical_speciality_data.dart';
import 'package:pppd_project/models/price_data.dart';
import 'package:pppd_project/models/service_data.dart';
import 'package:pppd_project/models/type_of_medical_care_data.dart';

// Класс модели оказанных мед услуг
class ProvidedAssistanceData {
  int? typeOfMedicalCareId, servicesRenderedId;
  AppealData? appealData;
  TypeOfMedicalCareData? typeOfMedicalCareData;
  ServiceData? serviceData;
  PriceData? priceData;
  IncomesAndExpensesData? incomesAndExpensesData;
  MedicalSpecialityData? medicalSpecialityData;
// Инициализация переменных класса
  ProvidedAssistanceData(
      {this.typeOfMedicalCareId,
      this.servicesRenderedId,
      this.appealData,
      this.typeOfMedicalCareData,
      this.serviceData,
      this.priceData,
      this.incomesAndExpensesData,
      this.medicalSpecialityData});
// Функция которая передает переменным класса значения из json
  factory ProvidedAssistanceData.fromJSON(Map<String, dynamic> parsedJson) {
    return ProvidedAssistanceData(
      typeOfMedicalCareId: parsedJson['typeOfMedicalCareId'],
      servicesRenderedId: parsedJson['servicesRenderedId'],
      appealData: parsedJson['services'] != null
          ? AppealData.fromJSON(parsedJson['services'])
          : null,
      typeOfMedicalCareData: parsedJson['typeOfMedicalCare'] != null
          ? TypeOfMedicalCareData.fromJSON(parsedJson['typeOfMedicalCare'])
          : null,
      serviceData: parsedJson['service'] != null
          ? ServiceData.fromJSON(parsedJson['service'])
          : null,
      priceData: parsedJson['price'] != null
          ? PriceData.fromJSON(parsedJson['price'])
          : null,
      incomesAndExpensesData: parsedJson['costsAndExpenses'] != null
          ? IncomesAndExpensesData.fromJSON(parsedJson['costsAndExpenses'])
          : null,
      medicalSpecialityData: parsedJson['speciality'] != null
          ? MedicalSpecialityData.fromJSON(parsedJson['speciality'])
          : null,
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    return {
      'typeOfMedicalCareId': typeOfMedicalCareId,
      'servicesRenderedId': servicesRenderedId,
    };
  }
}
