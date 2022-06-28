// Класс модели цен
class PriceData {
  int? id;
  String? price;
// Инициализация переменных класса
  PriceData({
    this.id,
    this.price,
  });
// Функция которая передает переменным класса значения из json
  factory PriceData.fromJSON(Map<String, dynamic> parsedJson) {
    return PriceData(
      id: parsedJson['idPrice'],
      price: parsedJson['price1'].toString(),
    );
  }
}
