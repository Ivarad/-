import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:pppd_project/presentation/patient_personal_area.dart';
import 'package:pppd_project/presentation/settings.dart';
import 'package:pppd_project/presentation/home.dart';
import 'package:pppd_project/helpers/authorizated.dart';

// Класс создающий виджеты экрана личного кабинета врача
class PersonalAreaDoctor extends StatefulWidget {
  const PersonalAreaDoctor({Key? key}) : super(key: key);

  @override
  State<PersonalAreaDoctor> createState() => _PersonalAreaDoctorState();
}

// Класс определяющий состояние виджетов
class _PersonalAreaDoctorState extends State<PersonalAreaDoctor> {
  // Лист в котором содержатся даты начиная от текущей и далее до 8 дня
  final List<String> filter = [
    DateFormat('dd.MM.yyyy').format(DateTime.now()),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 1))),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 2))),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 3))),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 4))),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 5))),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 6))),
    DateFormat('dd.MM.yyyy')
        .format(DateTime.now().add(const Duration(days: 7))),
  ];
  String? dropdownValue = DateFormat('dd.MM.yyyy').format(
      DateTime.now()); // Переменная содержащая значение выбранное с списке

  List<AppealData> appeals = []; // Лист содержащий все обращения
  List<AppealData> appealsSelected =
      []; // Лист содержащий все отфильтрованные обращения конкретно к этому врачу

  bool _isPatientLoading = true; // Статус загрузки обращений пациентов
  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    super.initState();
    filterPatients();
    setState(() {});
  }

// Метод наполняющий лист обращений
  Future getAppeals() async {
    appeals = await NetworkServices().getAppeals();
  }

// Метод фильтрующий обращения к врачу на выбранную дату
  filterPatients() async {
    if (await CheckNetwork().checkConnection(context)) {
      _isPatientLoading = true;
      await getAppeals();
      List<String> listdata = await Authorizated().getAuthorizated();

      if (DateFormat('dd.MM.yyyy')
              .format(DateFormat('dd.MM.yyyy').parse(dropdownValue!)) ==
          DateFormat('dd.MM.yyyy').format(DateTime.now())) {
        appealsSelected = appeals
            .where((element) =>
                DateTime.parse(DateFormat('dd.MM.yyyy')
                            .parse(
                                '${dropdownValue!}${DateTime.now().toString().substring(10, 18)}')
                            .toString())
                        .compareTo(DateFormat('yyyy-MM-dd').parse(
                            '${element.dateOfRendering!.substring(0, 10)}')) ==
                    0 &&
                element.employeeData!.accountId.toString() == listdata[1] &&
                element.closed == false)
            .toList();
      } else {
        appealsSelected = appeals
            .where((element) =>
                DateTime.parse(DateFormat('dd.MM.yyyy')
                            .parse(dropdownValue!)
                            .toString())
                        .compareTo((DateFormat('yyyy-MM-dd').parse(
                            element.dateOfRendering!.substring(0, 10)))) ==
                    0 &&
                element.employeeData!.accountId.toString() == listdata[1] &&
                element.closed == false)
            .toList();
      }
      _isPatientLoading = false;
      if (appealsSelected.isEmpty) {
        Message().message('На выбранную дату записи отсутствуют!', context);
      }
      setState(() {});
    }
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(100, 100, 200, 90),
              ),
              child: BorderedText(
                strokeWidth: 2.0,
                strokeColor: const Color.fromARGB(90, 0, 0, 0),
                child: const Text(
                  'Система УСОМП',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: const Text('Настройки'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Выход'),
              onTap: () async {
                await Authorizated().deleteKeys();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                    (_) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Личный кабинет',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              items: filter.map((String singleItem) {
                return DropdownMenuItem<String>(
                    value: singleItem, child: Text(singleItem));
              }).toList(),
              onChanged: (String? itemChosen) {
                setState(() {
                  dropdownValue = itemChosen;
                  _isPatientLoading = true;
                });
                filterPatients();
              },
              value: dropdownValue,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _isPatientLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (MediaQuery.of(context).size.width / 350)
                                        .round(),
                                childAspectRatio: (150 / 60),
                              ),
                              itemCount: appealsSelected.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    if (DateFormat('dd.MM.yyyy').format(
                                            DateFormat('dd.MM.yyyy')
                                                .parse(dropdownValue!)) ==
                                        DateFormat('dd.MM.yyyy')
                                            .format(DateTime.now())) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalAreaPatient(
                                            patientAndDoctor: false,
                                            appealPatient:
                                                appealsSelected[index],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            68, 63, 175, 40),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    margin: const EdgeInsets.all(5),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Center(
                                        child: Text(
                                          'Пациент: ${appealsSelected[index].medicalCardData!.surname} ${appealsSelected[index].medicalCardData!.name} ${appealsSelected[index].medicalCardData!.patronymic} \n' +
                                              'Дата первичного обращения: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(appealsSelected[index].dateFirstAppealData!.dateFirstAppeal.toString()))} \n' +
                                              'Дата и время приема: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(appealsSelected[index].dateOfRendering.toString()))} ${appealsSelected[index].scheduleData!.time}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
