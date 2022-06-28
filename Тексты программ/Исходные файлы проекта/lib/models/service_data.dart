import 'package:pppd_project/models/incomes_and_expenses_data.dart';
import 'package:pppd_project/models/price_data.dart';

// Класс модели услуг
class ServiceData {
  int? id;
  String? service;
  int? priceId, costsAndExpensesId;
  PriceData? priceData;
  IncomesAndExpensesData? incomesAndExpensesData;
// Инициализация переменных класса
  ServiceData(
      {this.id,
      this.service,
      this.priceId,
      this.costsAndExpensesId,
      this.priceData,
      this.incomesAndExpensesData});
// Функция которая передает переменным класса значения из json
  factory ServiceData.fromJSON(Map<String, dynamic> parsedJson) {
    return ServiceData(
      id: parsedJson['idService'],
      service: parsedJson['service1'],
      priceId: parsedJson['priceId'],
      costsAndExpensesId: parsedJson['costsAndExpensesId'],
      priceData: parsedJson['price'] != null
          ? PriceData.fromJSON(parsedJson['price'])
          : null,
      incomesAndExpensesData: parsedJson['costsAndExpenses'] != null
          ? IncomesAndExpensesData.fromJSON(parsedJson['costsAndExpenses'])
          : null,
    );
  }
}
