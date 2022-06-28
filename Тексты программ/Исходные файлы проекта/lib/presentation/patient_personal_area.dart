import 'package:flutter/cupertino.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/presentation/patient_appeal_info.dart';
import 'package:pppd_project/presentation/settings.dart';
import 'package:pppd_project/presentation/home.dart';
import 'package:pppd_project/presentation/make_an_appointment.dart';
import 'package:pppd_project/presentation/selected_appeal.dart';
import 'package:pppd_project/helpers/authorizated.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:intl/intl.dart';

// Класс создающий виджеты экрана личного кабинета пользователя
class PersonalAreaPatient extends StatefulWidget {
  const PersonalAreaPatient(
      {Key? key, required this.patientAndDoctor, required this.appealPatient})
      : super(key: key);
  final bool
      patientAndDoctor; // Переменная параметр класса, содержащая в себе значение соответсвующее тому, кто авторизован - врач или пациент
  final AppealData
      appealPatient; // Переменная параметр класса, содержащая в себе значение обращения
  @override
  State<PersonalAreaPatient> createState() => _PersonalAreaPatientState();
}

// Класс определяющий состояние виджетов
class _PersonalAreaPatientState extends State<PersonalAreaPatient> {
  int selectedItem =
      -1; // Переменная содержащая в себе значение выбранного обращения в списке

  String floatingButtonText =
      ''; // Переменная определяющая текст кнопки записи на прием / текущего обращения
  List<AppealData> appeals = []; // Лист содержащий все обращения пациентов
  List<AppealData> appealsPatient =
      []; // Лист содержащий отфильтрованные обращения пациента
  bool _isLoading = true; // Переменная определяющая состояние получения данных
//Лист содержащий фильтр новых и тарых обращений
  final List<String> filter = [
    'Новые обращения',
    'Старые обращения',
  ];
  String? dropdownValue =
      'Новые обращения'; // Переменная содержащая значение выбранного элемента списка
  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    floatingButtonText =
        widget.patientAndDoctor ? 'Записаться на прием' : 'Текущее обращение';

    super.initState();

    if (widget.patientAndDoctor) {
      filterAppeal();
    } else {
      filterToDoctorAppeal();
      dropdownValue = 'Старые обращения';
    }
    setState(() {});
  }

// Метод получающий данные об обращениях пациента как для пациента - все его обращения к врачам, так и для врача - все обращения пациента к себе
  Future getAppeals() async {
    appeals = await NetworkServices().getAppeals();
    if (widget.patientAndDoctor) {
      List<String> listdata = await Authorizated().getAuthorizated();
      appeals = appeals
          .where((element) =>
              element.patientData!.accountId.toString() == listdata[1])
          .toList();
    } else {
      List<String> listdata = await Authorizated().getAuthorizated();
      appeals = appeals
          .where((element) =>
              element.employeeData!.accountId.toString() == listdata[1] &&
              element.patientId == widget.appealPatient.patientId)
          .toList();
    }
  }

// Метод фильтрующий старые обращения пациента для врача
  Future filterToDoctorAppeal() async {
    if (await CheckNetwork().checkConnection(context)) {
      await getAppeals();
      setState(() {
        appealsPatient = appeals
            .where(
              (element) =>
                  DateTime.now().compareTo((DateFormat('yyyy-MM-dd H:mm:ss').parse(
                      '${element.dateOfRendering!.substring(0, 10)} ${element.scheduleData?.time}:00'))) ==
                  1,
            )
            .toList();
      });

      _isLoading = false;
      if (appealsPatient.isEmpty) {
        Message().message('У пацинета отсутствуют обращения!', context);
      }
    }
  }

// Метод фильтрующий старые и новые обращения для пациента
  Future filterAppeal() async {
    await getAppeals();
    setState(() {
      if (appeals.isNotEmpty) {
        if (dropdownValue == 'Новые обращения') {
          appealsPatient = appeals
              .where(
                (element) =>
                    DateTime.now().compareTo((DateFormat('yyyy-MM-dd H:mm:ss')
                        .parse(
                            '${element.dateOfRendering!.substring(0, 10)} ${element.scheduleData?.time}:00'))) ==
                    -1,
              )
              .toList();
        } else {
          appealsPatient = appeals
              .where(
                (element) =>
                    DateTime.now().compareTo((DateFormat('yyyy-MM-dd H:mm:ss')
                        .parse(
                            '${element.dateOfRendering!.substring(0, 10)} ${element.scheduleData?.time}:00'))) ==
                    1,
              )
              .toList();
        }
      }
    });
    _isLoading = false;
    if (appealsPatient.isEmpty) {
      Message().message('По выбранному фильтру обращения осутствуют!', context);
    }
  }

// Метод отменяющий обращение (удаляющий)
  Future deleteAppeal(int id) async {
    await NetworkServices().deleteAppeals(id);
  }

// Функция возвращающая виджет диалогового окна CupertinoDialog, для отмены записи к врачу
  void showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Отменить обращение"),
          content: Text(
              'Вы уверены что хотите отменить запись на прием к врачу:  ${appealsPatient[selectedItem].medicalSpecialityData?.speciality ?? '*'} ' +
                  ' ${appealsPatient[selectedItem].employeeData!.surname} ${appealsPatient[selectedItem].employeeData!.name} ${appealsPatient[selectedItem].employeeData!.patronymic}, ' +
                  'на дату: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(appealsPatient[selectedItem].dateOfRendering.toString()))} ${appealsPatient[selectedItem].scheduleData!.time} '),
          actions: [
            CupertinoDialogAction(
                child: const Text("Да"),
                onPressed: () {
                  deleteAppeal(appealsPatient[selectedItem].id!.toInt());
                  setState(() {
                    appealsPatient.removeWhere((element) =>
                        element.id == appealsPatient[selectedItem].id);
                  });
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: const Text("Нет"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.patientAndDoctor
          ? Drawer(
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
            )
          : null,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.patientAndDoctor ? 'Ваши обращения' : 'Обращения пациента',
          style: const TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 77, 163, 51),
          ),
          alignment: Alignment.centerRight,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(
                color: Color.fromARGB(255, 72, 209, 45),
              ),
            ),
          ),
        ),
        onPressed: () {
          if (widget.patientAndDoctor) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MakeAnAppointment(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectedAppeal(
                  appealPatient: widget.appealPatient,
                ),
              ),
            );
          }
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                floatingButtonText,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
              )),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.patientAndDoctor
                ? DropdownButton<String>(
                    alignment: Alignment.topCenter,
                    items: filter.map((String singleItem) {
                      return DropdownMenuItem<String>(
                          value: singleItem, child: Text(singleItem));
                    }).toList(),
                    onChanged: (String? itemChosen) {
                      _isLoading = true;
                      setState(() {
                        dropdownValue = itemChosen;
                        _isLoading = true;
                      });

                      filterAppeal();
                    },
                    value: dropdownValue,
                  )
                : Container(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (MediaQuery.of(context).size.width / 200)
                                        .round(),
                                childAspectRatio: (150 / 150),
                              ),
                              itemCount: appealsPatient.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatientAppealInfo(
                                          appealInfo: appealsPatient[index],
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    if (dropdownValue == 'Новые обращения') {
                                      setState(() {
                                        selectedItem = index;
                                      });
                                      if (selectedItem > -1) {
                                        showDialog();
                                      }
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
                                          dropdownValue.toString() ==
                                                  'Новые обращения'
                                              ? 'Врач: ${appealsPatient[index].medicalSpecialityData?.speciality ?? '*'} \n${appealsPatient[index].employeeData!.surname} ${appealsPatient[index].employeeData!.name}' +
                                                  '  ${appealsPatient[index].employeeData!.patronymic} \nДата и время приема:\n ${DateFormat('dd.MM.yyyy').format(DateTime.parse(appealsPatient[index].dateOfRendering.toString()))} ${appealsPatient[index].scheduleData!.time}\n' +
                                                  'Кабинет: ${appealsPatient[index].cabinetData!.id}'
                                              : 'Врач: ${appealsPatient[index].medicalSpecialityData?.speciality ?? '*'} \n${appealsPatient[index].employeeData!.surname} ${appealsPatient[index].employeeData!.name}' +
                                                  '  ${appealsPatient[index].employeeData!.patronymic} \nДата и время приема:\n ${DateFormat('dd.MM.yyyy').format(DateTime.parse(appealsPatient[index].dateOfRendering.toString()))} ${appealsPatient[index].scheduleData!.time}\n',
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
