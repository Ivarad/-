import 'package:pppd_project/models/medical_card_data.dart';

// Класс модели пацинета
class PatientData {
  int? id, accountId, medicalCardId;
  MedicalCardData? medicalCardData;
// Инициализация переменных класса
  PatientData(
      {this.id, this.accountId, this.medicalCardId, this.medicalCardData});
// Функция которая передает переменным класса значения из json
  factory PatientData.fromJSON(Map<String, dynamic> parsedJson) {
    return PatientData(
      id: parsedJson['idPatient'],
      accountId: parsedJson['accountId'],
      medicalCardId: parsedJson['medicalCardId'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idPatient'] = id;
    data['accountId'] = accountId;
    data['medicalCardId'] = medicalCardId;

    return data;
  }
}
