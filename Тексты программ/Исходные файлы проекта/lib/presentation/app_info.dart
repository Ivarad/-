import 'package:flutter/material.dart';

// Класс создающий виджеты экрана информации о приложении
class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

// Класс определяющий состояние виджетов
class _AppInfoState extends State<AppInfo> {
  // Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'О приложении',
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: const Color.fromARGB(80, 72, 190, 48),
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  margin: const EdgeInsets.all(5),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Система учета статистики оказания медицинской помощи V2, кросплатформенно приложение. Приложение предназначено для использования в ГАУЗ «СП №48 ДЗМ»',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            )));
  }
}
