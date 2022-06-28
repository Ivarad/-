// Класс модели типов бюджета
class BudgetTypeData {
  int? id;
  String? budgetType;
// Инициализация переменных класса
  BudgetTypeData({
    this.id,
    this.budgetType,
  });
// Функция которая передает переменным класса значения из json
  factory BudgetTypeData.fromJSON(Map<String, dynamic> parsedJson) {
    return BudgetTypeData(
      id: parsedJson['idBudgetType'],
      budgetType: parsedJson['budgetType1'],
    );
  }
// Парсинг переменных класса в json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idBudgetType'] = id;
    data['budgetType1'] = budgetType;
    return data;
  }
}
