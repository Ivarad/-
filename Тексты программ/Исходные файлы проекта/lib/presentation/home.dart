import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:pppd_project/models/user_data.dart';
import 'package:pppd_project/presentation/patient_personal_area.dart';
import 'package:pppd_project/presentation/analyst_personal_area.dart';
import 'package:pppd_project/presentation/doctor_personal_area.dart';
import 'package:pppd_project/presentation/change_password.dart';
import 'package:pppd_project/presentation/registration.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/authorizated.dart';

// Класс создающий виджеты главного экрана
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _AppState();
}

// Класс определяющий состояние виджетов
class _AppState extends State<Home> {
  String? _login; // Переменная принимающая значение логина
  String? _password; // Переменная принимающая значение пароля
  bool _isLoadingData = false;
  final _formKey = GlobalKey<
      FormState>(); // Переменная принимающая ключ проверки валидации полей

  bool _isObscure =
      true; // Переменная определяющая видимость значений в полях паролей

  List<UserData> usersList = []; // Лист пользователей

  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    super.initState();
  }

  // Метод наполняющий данными лист пользователей
  Future getUsers(String login, String password) async {
    usersList = await NetworkServices().getUserCheckPassword(login, password);
  }

  // Метод авторизации, опередляющий данные пользователя на запись и направляющий пользователя в свой кабинет в зависимости от роли
  authorization(int roleId, int accountId, String email) async {
    await Authorizated().setAuthorizated(true, accountId, roleId, email);
    debugPrint("Role: " + roleId.toString());
    switch (roleId) {
      case 1:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalAreaPatient(
                patientAndDoctor: true,
                appealPatient: AppealData(),
              ),
            ),
            (_) => false);
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalAreaDoctor(),
            ),
            (_) => false);

        break;
      case 3:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalAreaAnalyst(),
            ),
            (_) => false);
        break;
    }
  }

  // Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Система УСОМП',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                'Авторизация',
                style: TextStyle(fontSize: 28),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      maxLength: 100,
                      decoration: const InputDecoration(
                        hintText: "Введите логин",
                        labelText: "Логин",
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
                        _login = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле логина';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      maxLength: 100,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            child: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        hintText: "Введите пароль",
                        labelText: "Пароль",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(65, 57, 57, 148),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(65, 172, 50, 20),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле пароля';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            _isLoadingData
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(197, 77, 163, 51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                onPressed: () async {
                  if (await CheckNetwork().checkConnection(context)) {
                    if (_formKey.currentState!.validate()) {
                      _isLoadingData = true;
                      setState(() {});
                      await getUsers(_login!, _password!);
                      UserData? account = usersList.singleWhere(
                          (account) =>
                              account.login == _login || account.email == _login,
                          orElse: () => UserData(roleId: -1));
                      _isLoadingData = false;
                      setState(() {});
                      if (account.roleId != -1) {
                        await authorization(
                            account.roleId!, account.id!, account.email!);
                      } else {
                        Message().message('Неверный логин или пароль!', context);
                      }
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Авторизоваться",
                    style: TextStyle(
                        fontSize: 28, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(197, 77, 163, 51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                onPressed: () async {
                  if (await CheckNetwork().checkConnection(context)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Registration(),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Регистрация",
                    style: TextStyle(
                        fontSize: 28, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(197, 77, 163, 51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                onPressed: () async {
                  if (await CheckNetwork().checkConnection(context)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(
                          authorizated: false,
                        ),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Восстановление пароля",
                    style: TextStyle(
                        fontSize: 26, color: Color.fromARGB(255, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
