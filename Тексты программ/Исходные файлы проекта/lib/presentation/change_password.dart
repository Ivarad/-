import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/helpers/authorizated.dart';
import 'package:pppd_project/models/user_data.dart';

// Класс создающий виджеты экрана смены пароля
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.authorizated})
      : super(key: key);
  final bool
      authorizated; // Переменная параметр класса, содержащая в себе значение соответсующее авторизованному пользователю

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_ChangePasswordState>()?.restartApp();
  } // Метод реализующий перезапуск экрана

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

// Класс определяющий состояние виджетов
class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  Key key =
      UniqueKey(); // Переменная содежащая в себе ключ, для успешного обновления состояния экрана при перезапуске
  String? _checkCode =
      ''; // Переменная содержащая код проверки введенный пользователем
  String? _newPassword; // Переменная содержащая новый пароль
  String? _rePassword; // Переменная содержащая повторенный пароль
  String? _emailOrLogin; // Переменная содержащая почту или логин
  final _formKey = GlobalKey<
      FormState>(); // Переменная принимающая ключ проверки валидации полей
  bool _codeSended =
      false; // Переменная содержащая в себе значение соответсвующее отправке кода подтверждения на почту
  bool _isLoad =
      false; // Переменная содержащая в себе значение соответсвующее получению данных
  String? _code =
      ''; // Переменная содержащая код проверки отправленный на почту
  NetworkServices?
      _networkServices; // Переменная содержащая в себе экземпляр класса для работы с API
  List<UserData> usersList = []; // Лист содержащий пользователей
  List<String> listdata =
      []; // Лист содержащий данные авторизованного пользователя
  bool _isObscure =
      true; // Переменная содержащая значение соответствующее отображению значения в поле нового пароля
  bool _isReObscure =
      true; // Переменная содержащая значение соответствующее отображению значения в поле повтора пароля
// Метод вызывающий перезапуск экрана
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    _networkServices = NetworkServices();
    super.initState();
  }

// Метод отправляющий код на почту пользователя
  Future? _isCodeSended() async {
    String? email;
    listdata = await Authorizated().getAuthorizated();
    setState(() {
      _isLoad = true;
      _codeSended = true;
    });

    if (await checkAccount()) {
      Message().message(
          'Аккаунта с таким логином или почтой не сущестивует!', context);
      setState(() {
        _codeSended = false;
        _isLoad = false;
      });
    } else {
      email = usersList[0].email;
    }

    _code = await _networkServices?.changePasswordCodeSend(email!);
    setState(() {
      _isLoad = false;
    });
  }

// Метод меняющий пароль пользователя
  Future changePassword() async {
    UserData userUpdate = UserData();
    userUpdate = usersList[0];
    userUpdate.password = _rePassword;
    await NetworkServices().editUser(userData: userUpdate, id: userUpdate.id!);
  }

// Функция поиска аккаунта по почте или логину, возвращающая соответствующий результат
  Future<bool> checkAccount() async {
    bool check = false;
    usersList = await NetworkServices().getUsers();
    if (!widget.authorizated) {
      usersList = usersList
          .where((element) =>
              element.email == _emailOrLogin || element.login == _emailOrLogin)
          .toList();
    } else {
      usersList = usersList
          .where((element) => element.id.toString() == listdata[1])
          .toList();
    }

    if (usersList.isEmpty) {
      check = true;
    }
    return check;
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Смена пароля',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  widget.authorizated
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 30),
                          child: TextFormField(
                            maxLength: 200,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9A-z!.?@]")),
                            ],
                            decoration: const InputDecoration(
                              hintText: "Введите почту или логин",
                              labelText: "Почта/логин",
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
                              _emailOrLogin = value;
                            },
                            validator: (value) {
                              if (value!.trim() == '') {
                                return 'Заполните поле!';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        top: widget.authorizated ? 30 : 0),
                    child: TextFormField(
                      maxLength: 10,
                      enabled: _codeSended,
                      decoration: const InputDecoration(
                        hintText: "Введите код",
                        labelText: "Код подтверждения",
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
                        _checkCode = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле кода подтверждения';
                        } else if (_code != value) {
                          return 'Коды не совпадают!';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  _isLoad
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                  _codeSended
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(197, 77, 163, 51),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0))),
                            onPressed: _isCodeSended,
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                'Получить код',
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      maxLength: 100,
                      obscureText: _isObscure,
                      keyboardType: TextInputType.visiblePassword,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9A-z!.?@]")),
                      ],
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
                        hintText: "Введите новый пароль",
                        labelText: "Новый пароль",
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
                        _newPassword = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполнить поле пароля';
                        } else if (value.length < 8) {
                          return 'Пароль должен быть не меньше 8 символов!';
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
                      obscureText: _isReObscure,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            child: Icon(_isReObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                _isReObscure = !_isReObscure;
                              });
                            }),
                        hintText: "Повторите пароль",
                        labelText: "Повтор пароля",
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
                        _rePassword = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполнить поле пароля';
                        } else if (value != _newPassword) {
                          return 'Пароли отличаются';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 40,
                ),
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(197, 77, 163, 51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (await CheckNetwork().checkConnection(context)) {
                      if (_code == _checkCode && _checkCode != '') {
                        changePassword();
                        Message().message('Успешная смена пароля', context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(
                                authorizated: widget.authorizated,
                              ),
                            ));
                      }
                    }
                  } else {
                    if (_checkCode == '') {
                      Message().message('Введите код подтверждения!', context);
                    }
                  }
                },
                label: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Сменить пароль",
                    style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 255, 255, 255)),
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
