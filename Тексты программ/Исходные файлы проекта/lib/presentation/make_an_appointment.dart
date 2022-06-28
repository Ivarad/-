import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/helpers/authorizated.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:pppd_project/models/dates_first_appeal_data.dart';
import 'package:pppd_project/models/medical_speciality_data.dart';
import 'package:pppd_project/models/patient_data.dart';
import 'package:pppd_project/models/schedule_data.dart';
import 'package:pppd_project/presentation/patient_personal_area.dart';

// Класс создающий виджеты экрана записи на прием
class MakeAnAppointment extends StatefulWidget {
  const MakeAnAppointment({Key? key}) : super(key: key);

  @override
  State<MakeAnAppointment> createState() => _MakeAnAppointmentState();
}

// Класс определяющий состояние виджетов
class _MakeAnAppointmentState extends State<MakeAnAppointment> {
  // Лист содержащий базовые специальности врачей
  final List<String> specialityList = [
    'Выберите специальность врача',
    'Терапевт',
    'Хирург',
  ];

  String? dropdownSpeciality =
      'Выберите специальность врача'; // Переменная содержащая в себе значение выбранной специальности в списке
// Лист содержащий базовые виды бюджета
  final List<String> budgetTypeList = [
    'Выберите тип бюджета',
    'ОМС',
    'За свой счет',
    'ЛЗП',
  ];

  String? dropdownBudgetType =
      'Выберите тип бюджета'; // Переменная содержащая в себе значение выбранного типа бюджета
  bool _isDocotorsLoading =
      false; // Переменная содержащая в себе состояние получения данных о врачах
  bool _isButtonClicked =
      false; // Переменная хранящая в себе состояние нажатия кнопки

  List<AppealData> appeals = []; // Лист содеражащий в себе обращения пациентов

  List<MedicalSpecialityData> doctorsInfo =
      []; // Лист содержащий в себе специальности врачей вместе с данными о врачах
  List<MedicalSpecialityData> selectedDoctorsInfo =
      []; // Лист содержащий в себе информацию о врачах по выбранной специальности в списке

  List<ScheduleData> schedules = []; // Лист содеражащий расписание
  List<ScheduleData> selectedSchedules =
      []; // Лист содержащий расписание врача по данный специальности
  List<List<ScheduleData>> scheduleMatrix =
      []; // Матрица содеражащая отфильтрованное расписание выбранного врача
  int _whenPostAppeal =
      30; // Переменная определающая колиство столбцов в матрице
  int selectedIndex =
      -1; // Переменная содержащая в себе индекс выбранного сотрудрника в списке
// Лист содержащий индексы выбранного времени и даты
  List<int> selectedDateAndTime = [-1, -1];
// Лист содержащий даты первичного обращения
  List<DateFirstAppealData> datesFirstRendereds = [];
  // Лист содержащий пациентов
  List<PatientData> patients = [];
  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    getDoctorsAndSchedules();
    super.initState();
  }

// Метод наполняющий листы данными о врачах, их расписании и обращениях пациентов
  Future getDoctorsAndSchedules() async {
    doctorsInfo = await NetworkServices().getAllInfoDocotor();
    schedules = await NetworkServices().getDocotorSchedule();
    appeals = await NetworkServices().getAppeals();
  }

// Метод вызывающий фукнцию создания нового обращения
  Future postAppeal(AppealData appealData) async {
    await NetworkServices().createAppeal(appealInfo: appealData);
    setState(() {
      _isDocotorsLoading = false;
    });
  }

// Метод создающий новую дату первичного обращения
  Future postDate() async {
    DateFirstAppealData? dateFirstAppealData = DateFirstAppealData();
    dateFirstAppealData.dateFirstAppeal =
        DateTime.now().add(Duration(days: selectedDateAndTime[0])).toString();
    await NetworkServices()
        .createDateFirstRendering(dateFirstAppealData: dateFirstAppealData);
    datesFirstRendereds = await NetworkServices().getDateFirstAppeal();
  }

// Метод создания обращения с учетом даты первчиного обращения, существования пациента, его текущих обращениях и датах первчиного обращения, а также выбранного врача
  createAppeal() async {
    patients = await NetworkServices().getPatients();
    AppealData temp = AppealData();
    List<String> listdata = await Authorizated().getAuthorizated();
    if (appeals
        .where((element) =>
            element.employeeData!.id ==
                selectedDoctorsInfo[selectedIndex].employeeId &&
            element.patientData!.accountId.toString() == listdata[1])
        .isNotEmpty) {
      AppealData tempAppeal = appeals.lastWhere((element) =>
          element.employeeData!.id ==
              selectedDoctorsInfo[selectedIndex].employeeId &&
          element.patientData!.accountId.toString() == listdata[1]);
      if (tempAppeal.closed == true) {
        await postDate();
        temp.dateFirstAppealData = datesFirstRendereds.lastWhere((element) =>
            element.dateFirstAppeal.toString().contains(DateTime.now()
                .add(Duration(days: selectedDateAndTime[0]))
                .toString()
                .substring(0, 10)));
        temp.dateFirstRenderedId = temp.dateFirstAppealData!.id;
      } else {
        temp.dateFirstAppealData = tempAppeal.dateFirstAppealData;
        temp.dateFirstRenderedId = tempAppeal.dateFirstRenderedId;
      }
      temp.patientId = tempAppeal.patientId;
    } else {
      postDate();
      datesFirstRendereds = await NetworkServices().getDateFirstAppeal();
      temp.dateFirstAppealData = datesFirstRendereds
          .where((element) =>
              element.dateFirstAppeal!.substring(0, 10) ==
              DateTime.now()
                  .add(Duration(days: selectedDateAndTime[0]))
                  .toString()
                  .substring(0, 10))
          .first;
      temp.dateFirstRenderedId = temp.dateFirstAppealData!.id;
      temp.patientId = patients
          .firstWhere((element) => element.accountId.toString() == listdata[1])
          .id;
    }

    temp.bugetTypeId = budgetTypeList.indexOf(dropdownBudgetType!);
    temp.dateOfRendering = DateTime.now()
        .add(Duration(days: selectedDateAndTime[0]))
        .toString()
        .substring(0, 10);
    temp.employeeId = selectedDoctorsInfo[selectedIndex].employeeId;

    temp.scheduleId = schedules
        .firstWhere((element) =>
            element.time ==
            scheduleMatrix[selectedDateAndTime[0]][selectedDateAndTime[1]].time)
        .id;
    temp.closed = false;

    await postAppeal(temp);
  }

// Метод фильтрующий лист врачей по специальности
  Future filterDoctors() async {
    _isDocotorsLoading = true;
    scheduleMatrix.clear();
    await getDoctorsAndSchedules();

    selectedDoctorsInfo = doctorsInfo
        .where((element) =>
            element.speciality.toString() == dropdownSpeciality.toString())
        .toList();
    _isDocotorsLoading = false;
    setState(() {});
  }

// Метод фильтрующий доступное время для записи, по врачам, уже существующим обращениям к ним в будущем времени
  filterSchedules() {
    scheduleMatrix.clear();
    List<AppealData> tempAppeals = [];
    List<ScheduleData> tempSchedules = [];

    tempAppeals = appeals
        .where((element) =>
            DateTime.now().compareTo((DateFormat('yyyy-MM-dd H:mm:ss').parse(
                    '${element.dateOfRendering!.substring(0, 10)} ${element.scheduleData!.time}:00'))) ==
                -1 &&
            element.employeeId == selectedDoctorsInfo[selectedIndex].employeeId)
        .toList();

    schedules.forEach((schedule) {
      schedule.doctorScheduleData!.forEach((doctorSchedule) {
        if (doctorSchedule.specialityId ==
            selectedDoctorsInfo[selectedIndex].specialityId) {
          tempSchedules.add(schedule);
        }
      });
    });

    for (int i = 0; i < 30; i++) {
      List<ScheduleData> temp = [];
      for (var schedule in tempSchedules) {
        if (tempAppeals.isNotEmpty) {
          for (var appeal in tempAppeals) {
            if (schedule.id == appeal.scheduleId &&
                DateFormat('yyyy-MM-dd').parse(DateTime.now()
                        .add(Duration(days: i))
                        .toString()
                        .substring(0, 10)) ==
                    (DateFormat('yyyy-MM-dd')
                        .parse(appeal.dateOfRendering!.substring(0, 10)))) {
              if (temp
                  .where((element) => element.time == schedule.time)
                  .isNotEmpty) {
                temp.remove(schedule);
              }
              break;
            } else {
              if (temp.where((element) => element == schedule).isEmpty) {
                temp.add(schedule);
              }
            }
          }
        } else {
          temp.add(schedule);
        }
      }
      if (i == 0) {
        temp.removeWhere(
          (element) =>
              DateTime.now().compareTo((DateFormat('yyyy-MM-dd H:mm:ss').parse(
                  '${DateTime.now().toString().substring(0, 10)} ${element.time}:00'))) ==
              1,
        );
      }
      scheduleMatrix.add(temp);
    }
  }

// Функция валидации при записи на прием, возвращающая значение соответсвующее корректности действий пользвотеля
  Future<bool> checkData() async {
    bool check = false;
    if (dropdownSpeciality == 'Выберите специальность врача') {
      Message().message('Вы не выбрали специальность врача!', context);
    } else if (selectedIndex == -1) {
      Message().message('Выберите врача!', context);
    } else if (selectedDateAndTime[0] == -1 || selectedDateAndTime[1] == -1) {
      Message().message('Выберите дату и время приема!', context);
    } else if (dropdownBudgetType == 'Выберите тип бюджета') {
      Message().message('Выберите тип бюджета!', context);
    } else if (!(await checkAppeal())) {
      Message().message(
          'У вас уже есть записи к врачам по данной специальности!', context);
    } else if (!(await checkOtherAppeal())) {
      Message().message(
          'Кто-то уже записался на это время, выберите другое время!', context);
      filterSchedules();
    } else {
      check = true;
    }
    if (!check) {
      setState(() {
        _isDocotorsLoading = false;
        _whenPostAppeal = 30;
      });
    }
    return check;
  }

// Функция проверки уже существующих записей на прием у пациента к врачам по выбранной специальности, возвращающая значение соответствующее существованию записей в будущем врмени
  Future<bool> checkAppeal() async {
    List<String> listdata = await Authorizated().getAuthorizated();
    var tempAppeals = appeals
        .where((element) =>
            DateTime.now().compareTo((DateFormat('yyyy-MM-dd H:mm:ss').parse(
                    '${element.dateOfRendering!.substring(0, 10)} ${element.scheduleData!.time}:00'))) ==
                -1 &&
            element.patientData!.accountId.toString() == listdata[1] &&
            element.medicalSpecialityData!.speciality ==
                selectedDoctorsInfo[selectedIndex].speciality)
        .toList();
    if (tempAppeals.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

// Функция проверки уже существующих записей на прием у пациентов к врачу по выбранной специальности, возвращающая значение соответствующее существованию записей на данной время
  Future<bool> checkOtherAppeal() async {
    await getDoctorsAndSchedules();
    var tempAppeals = appeals
        .where((element) =>
            element.scheduleId ==
                schedules
                    .firstWhere((element) =>
                        element.time ==
                        scheduleMatrix[selectedDateAndTime[0]]
                                [selectedDateAndTime[1]]
                            .time)
                    .id &&
            element.dateOfRendering!.substring(0, 10) ==
                DateTime.now()
                    .add(Duration(days: selectedDateAndTime[0]))
                    .toString()
                    .substring(0, 10) &&
            element.medicalSpecialityData!.specialityId ==
                selectedDoctorsInfo[selectedIndex].specialityId)
        .toList();
    if (tempAppeals.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Запись на прием',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              alignment: Alignment.center,
              items: specialityList.map((String singleItem) {
                return DropdownMenuItem<String>(
                    value: singleItem, child: Text(singleItem));
              }).toList(),
              onChanged: (String? itemChosen) {
                setState(() {
                  dropdownSpeciality = itemChosen;
                  selectedIndex = -1;
                  selectedDateAndTime = [-1, -1];
                });
                if (itemChosen != 'Выберите специальность врача') {
                  filterDoctors();
                } else {
                  Message().message('Выберите специальность врача', context);
                }
              },
              value: dropdownSpeciality,
            ),
            _isDocotorsLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator())
                : Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (MediaQuery.of(context).size.width / 200).round(),
                          childAspectRatio: (110 / 40),
                        ),
                        itemCount: selectedDoctorsInfo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              filterSchedules();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: index == selectedIndex
                                      ? const Color.fromARGB(166, 75, 202, 49)
                                      : const Color.fromARGB(68, 63, 175, 40),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              margin: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Center(
                                  child: Text(
                                    'Врач: ${selectedDoctorsInfo[index].employeeData!.surname} ${selectedDoctorsInfo[index].employeeData!.name} ' +
                                        '${selectedDoctorsInfo[index].employeeData!.patronymic}\nКабинет: ${selectedDoctorsInfo[index].cabinetData!.id}',
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
            Expanded(
              child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: scheduleMatrix.isNotEmpty ? _whenPostAppeal : 0,
                  itemBuilder: (BuildContext context, int indexlist) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Expanded(
                              child: ExpansionTile(
                                title: Text(DateFormat('dd.MM.yyyy').format(
                                        DateTime.now()
                                            .add(Duration(days: indexlist))) +
                                    ': '),
                                children: <Widget>[
                                  GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            (MediaQuery.of(context).size.width /
                                                    70)
                                                .round(),
                                        childAspectRatio: (60 / 40),
                                      ),
                                      itemCount: scheduleMatrix.isNotEmpty
                                          ? scheduleMatrix[indexlist].length
                                          : 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedDateAndTime[0] =
                                                    indexlist;
                                                selectedDateAndTime[1] = index;
                                              });
                                            },
                                            child: scheduleMatrix[indexlist]
                                                        [index]
                                                    .time!
                                                    .isNotEmpty
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      scheduleMatrix[indexlist]
                                                              [index]
                                                          .time
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: index ==
                                                                  selectedDateAndTime[
                                                                      1] &&
                                                              indexlist ==
                                                                  selectedDateAndTime[
                                                                      0]
                                                          ? const Color
                                                                  .fromARGB(
                                                              166, 75, 202, 49)
                                                          : const Color
                                                                  .fromARGB(
                                                              68, 63, 175, 40),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ))
                                                : Container());
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: DropdownButton<String>(
                items: budgetTypeList.map((String singleItem) {
                  return DropdownMenuItem<String>(
                      value: singleItem, child: Text(singleItem));
                }).toList(),
                onChanged: (String? itemChosen) {
                  setState(() {
                    dropdownBudgetType = itemChosen;
                  });
                },
                value: dropdownBudgetType,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(197, 77, 163, 51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                onPressed: _isDocotorsLoading
                    ? null
                    : () async {
                        setState(() {
                          _isDocotorsLoading = true;
                          _whenPostAppeal = 0;
                        });
                        if (!_isButtonClicked) {
                          if (await CheckNetwork().checkConnection(context)) {
                            _isButtonClicked = true;
                            if (await checkData()) {
                              await createAppeal();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonalAreaPatient(
                                    patientAndDoctor: true,
                                    appealPatient: AppealData(),
                                  ),
                                ),
                              );
                            } else {
                              _isButtonClicked = false;
                            }
                          }
                        }
                      },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Записаться",
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
