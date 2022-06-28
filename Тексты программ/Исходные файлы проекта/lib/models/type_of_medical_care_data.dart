import 'package:pppd_project/models/incomes_and_expenses_data.dart';
import 'package:pppd_project/models/medical_speciality_data.dart';
import 'package:pppd_project/models/price_data.dart';
import 'package:pppd_project/models/service_data.dart';

// Класс модели типов медицинской помощи и данных связанных с ними
class TypeOfMedicalCareData {
  int? id;
  String? typeOfMedicalCare;
  int? serviceId, specialtyId;
  ServiceData? serviceData;
  PriceData? priceData;
  IncomesAndExpensesData? incomesAndExpensesData;
  MedicalSpecialityData? medicalSpecialityData;
// Инициализация переменных класса
  TypeOfMedicalCareData(
      {this.id,
      this.typeOfMedicalCare,
      this.serviceId,
      this.specialtyId,
      this.serviceData,
      this.priceData,
      this.incomesAndExpensesData,
      this.medicalSpecialityData});
// Функция которая передает переменным класса значения из json
  factory TypeOfMedicalCareData.fromJSON(Map<String, dynamic> parsedJson) {
    return TypeOfMedicalCareData(
      id: parsedJson['idTypeOfMedicalCare'],
      typeOfMedicalCare: parsedJson['typeOfMedicalCare1'],
      serviceId: parsedJson['serviceId'],
      specialtyId: parsedJson['specialtyId'],
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
}
