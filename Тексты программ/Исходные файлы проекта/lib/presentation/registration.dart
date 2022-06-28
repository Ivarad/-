import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/models/medical_card_data.dart';
import 'package:pppd_project/models/patient_data.dart';
import 'package:pppd_project/models/user_data.dart';
import 'package:pppd_project/presentation/home.dart';

// Класс создающий виджеты экрана регистрации
class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

// Класс определяющий состояние виджетов
class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  String? _name,
      _surname,
      _patronymic = '',
      _oms,
      _snils,
      _email,
      _login,
      _password; // Переменные принимающие значения имени, фамилии, отчества, полиса ОМС, СНИЛС, почты, логина, пароля.
  bool _succes =
      false; // Переменная определяющая успешное создание пользователя
  bool _isAccountCreating =
      true; // Переменная определяющая процесс создания пользователя
  final _formKey = GlobalKey<
      FormState>(); // Переменная принимающая ключ проверки валидации полей
  bool _isObscure =
      true; // Переменная определяющая видимость значений в поле пароля
  final List<String> genderList = [
    'Выберите пол',
    'мужчина',
    'женщина'
  ]; // Лист гендеров
  String? dropdownValue =
      'Выберите пол'; // Переменная принимающая значние выбранного пола
  DateTime selectedDate = DateTime(
      DateTime.now().year - 16,
      DateTime.now().month,
      DateTime.now()
          .day); // Переменная принимающая значения выбранной даты рождения

  List<MedicalCardData> listMedicalCards = []; // Лист медкарт
  List<UserData> listUsers = []; // лист пользователей

// Метод вызывающий виджет DatePicker, для выбора даты рождения
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        locale: const Locale("ru", "RU"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 8),
        lastDate: DateTime(int.parse(DateTime.now().year.toString()) + 1));
    if (picked != null &&
        picked != selectedDate &&
        picked.isBefore(DateTime.now())) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

// Метод регистрации, он создает нового пользователя, новую медкарту и пациента
  Future createAccountPatient() async {
    _succes = false;
    _isAccountCreating = false;
    setState(() {});
    UserData user = UserData();
    MedicalCardData medicalCardData = MedicalCardData();
    PatientData patientData = PatientData();

    user.login = _login;
    user.email = _email;
    user.password = _password;
    user.roleId = 1;

    try {
      var checkuser = await NetworkServices().createUser(userData: user);
      if (checkuser!.login != 'Пользоватеть уже существует') {
        _succes = true;
      } else {
        await Message().message(
            'Уже существует пользователь с такими почтой или логином', context);
        _isAccountCreating = true;
        _succes = false;
      }
    } catch (e) {
      print('$e');
    }
    setState(() {});

    if (_succes) {
      listUsers = await NetworkServices().getUsers();
      UserData userNoResult = UserData();
      userNoResult.id = -1;
      patientData.accountId = listUsers
          .firstWhere(
              (element) => element.login == _login && element.email == _email,
              orElse: () => userNoResult)
          .id;
      if (patientData.accountId != -1) {
        medicalCardData.dateOfCompletion = DateTime.now().toString();
        medicalCardData.dateOfBirth = selectedDate.toString();
        medicalCardData.name = _name;
        medicalCardData.surname = _surname;
        medicalCardData.patronymic = _patronymic;
        if (dropdownValue == 'мужчина') {
          medicalCardData.genderId = 1;
        } else {
          medicalCardData.genderId = 2;
        }
        medicalCardData.chiPolicy = int.parse(_oms!);
        medicalCardData.snils = int.parse(_snils!);

        await NetworkServices()
            .createMedicalCard(medicalCardData: medicalCardData);
        listMedicalCards = await NetworkServices().getMedicalCard();

        patientData.medicalCardId = listMedicalCards
            .where((element) =>
                element.chiPolicy == int.parse(_oms!) &&
                element.snils == int.parse(_snils!) &&
                element.name == _name &&
                element.surname == _surname)
            .first
            .id;

        await NetworkServices().createPatient(patientData: patientData);
        _succes = true;
      } else {
        Message().message("Ошибка при создании учетной записи!", context);
        _succes = false;
      }
    }
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'Регистрация в системе',
          ),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 20),
                    child: TextFormField(
                      maxLength: 100,
                      enabled: _isAccountCreating,
                      decoration: const InputDecoration(
                        hintText: "Введите имя",
                        labelText: "Имя",
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
                        _name = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле имени!';
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
                      enabled: _isAccountCreating,
                      decoration: const InputDecoration(
                        hintText: "Введите фамилию",
                        labelText: "Фамилия",
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
                        _surname = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле фамилии!';
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
                      enabled: _isAccountCreating,
                      decoration: const InputDecoration(
                        hintText: "Введите отчество (необязательно)",
                        labelText: "Отчество",
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
                        _patronymic = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: DropdownButton<String>(
                      items: genderList.map((String singleItem) {
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
                  Text(
                    'Дата рождения ${DateFormat('dd.MM.yyyy').format(selectedDate)}',
                    style: const TextStyle(fontSize: 22),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(197, 77, 163, 51),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Выбрать дату рождения",
                          style: TextStyle(
                              fontSize: 22,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      maxLength: 16,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      enabled: _isAccountCreating,
                      decoration: const InputDecoration(
                        hintText: "Введите свой полис ОМС",
                        labelText: "ОМС",
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
                        _oms = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле ОМС!';
                        } else if (value.length != 16) {
                          return 'ОМС должен быть длинной в 16 цифр!';
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
                      maxLength: 11,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      enabled: _isAccountCreating,
                      decoration: const InputDecoration(
                        hintText: "Введите СНИЛС",
                        labelText: "СНИЛС",
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
                        _snils = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле СНИЛСа!';
                        } else if (value.length != 11) {
                          return 'СНИЛС должен быть длинной в 11 цифр!';
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
                      maxLength: 200,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9A-z!.?@]")),
                      ],
                      enabled: _isAccountCreating,
                      decoration: const InputDecoration(
                        hintText: "Введите свою электронную почту",
                        labelText: "Почта",
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
                        _email = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните почты!';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Неправильный адрес почты!';
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
                      enabled: _isAccountCreating,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9A-z!.?@]")),
                      ],
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
                        } else if (value.length < 8 || value.contains(' ')) {
                          return 'Логин должен быть не меньше 8 символов, и не включать пробелы';
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
                      enabled: _isAccountCreating,
                      maxLength: 100,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9A-z!.?@]")),
                      ],
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
                        } else if (value.length < 8 || value.contains(' ')) {
                          return 'Пароль должен быть не меньше 8 символов, и не включать пробелы';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            _isAccountCreating
                ? Container()
                : const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(197, 77, 163, 51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _isAccountCreating) {
                    if (await CheckNetwork().checkConnection(context)) {
                      if (dropdownValue == 'Выберите пол') {
                        Message().message('Выберите пол!', context);
                      } else if (selectedDate.isAfter(DateTime(
                          DateTime.now().year - 16,
                          DateTime.now().month,
                          DateTime.now().day))) {
                        Message().message(
                            'Выберите дату рождения! В системе можно зарегистрироваться если вы не младше 16 лет!',
                            context);
                      } else {
                        await createAccountPatient();
                        if (_succes) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                              (_) => false);
                          Message().message('Успешная регистрация', context);
                        } else {
                          _isAccountCreating = true;
                        }
                      }
                    }
                  } else {
                    Message().message('Неправильные данные', context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Зарегистрироваться",
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
