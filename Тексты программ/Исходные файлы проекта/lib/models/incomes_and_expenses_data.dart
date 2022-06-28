// Класс модели прибыли и затрат
class IncomesAndExpensesData {
  int? id;
  String? income, expenses;
// Инициализация переменных класса
  IncomesAndExpensesData({this.id, this.income, this.expenses});
// Функция которая передает переменным класса значения из json
  factory IncomesAndExpensesData.fromJSON(Map<String, dynamic> parsedJson) {
    return IncomesAndExpensesData(
      id: parsedJson['idCostsAndExpenses'],
      income: parsedJson['costs'].toString(),
      expenses: parsedJson['expenses'].toString(),
    );
  }
}
