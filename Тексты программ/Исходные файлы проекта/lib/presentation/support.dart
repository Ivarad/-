import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:url_launcher/url_launcher.dart';

// Класс создающий виджеты экрана технической поддеркжи
class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

// Класс определяющий состояние виджетов
class _SupportState extends State<Support> {
  final _formKey = GlobalKey<
      FormState>(); // Переменная принимающая ключ проверки валидации полей
  String? _message; // Переменная принимающая значение текста обращения
  final List<String> filter = [
    // Лист содержащий причны обращения
    'Выберите причину обращения',
    'Плохая оптимизация',
    'Ошибки',
    'Вылеты',
    'Другое'
  ];
  String? dropdownValue =
      'Выберите причину обращения'; // Перменная принимающая значение выбранной приичны обащения

// Метод запускающий почтовый клиент
  _sendingMails() async {
    final url =
        'mailto:SeclectEmployee@yandex.ru?subject=$dropdownValue&body=$_message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не получилось запустить $url';
    }
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Техническая поддержка',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: DropdownButton<String>(
                      items: filter.map((String singleItem) {
                        return DropdownMenuItem<String>(
                            value: singleItem, child: Text(singleItem));
                      }).toList(),
                      onChanged: (String? itemChosen) {
                        setState(() {
                          dropdownValue = itemChosen;
                        });
                      },
                      value: dropdownValue,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      maxLength: 300,
                      minLines: 5,
                      maxLines: 20,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Введите текст обращения",
                        labelText: "Обращение",
                        alignLabelWithHint: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(65, 57, 57, 148),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(65, 172, 50, 20),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _message = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле обращения!';
                        } else if (value.length < 30) {
                          return 'Минимальная длинна обращения 30 символов!';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(300),
                          primary: const Color.fromARGB(197, 77, 163, 51),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (dropdownValue != 'Выберите причину обращения') {
                            if (await CheckNetwork().checkConnection(context)) {
                              _sendingMails();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Support(),
                                  ));
                            }
                          } else {
                            Message().message(
                                'Выберите причину обращения!', context);
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Отправить",
                          style: TextStyle(
                              fontSize: 28,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
