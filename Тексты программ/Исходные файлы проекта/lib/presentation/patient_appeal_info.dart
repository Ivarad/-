import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:intl/intl.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/models/provided_assistance_data.dart';
import 'package:pppd_project/models/service_data.dart';

// Класс создающий виджеты экрана информации об обращении
class PatientAppealInfo extends StatefulWidget {
  const PatientAppealInfo({Key? key, required this.appealInfo})
      : super(key: key);
  final AppealData
      appealInfo; // Переменная параметр класса, содержащая в себе значение информации об обращении

  @override
  State<PatientAppealInfo> createState() => _PatientAppealInfoState();
}

// Класс определяющий состояние виджетов
class _PatientAppealInfoState extends State<PatientAppealInfo> {
  List<ProvidedAssistanceData> listProvidedAssistance =
      []; // Лист содержащий оказанные услуги и мед помощь
  List<ServiceData> listService = []; // Лист содержащий услуги
  String? _services =
      ''; // Переменная строки содержащий список оказанных усулг при обращении
  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    getServices();
    super.initState();
  }

  // Метод получающий данные об оказанных услугах при обращении
  Future getServices() async {
    if (await CheckNetwork().checkConnection(context)) {
      listProvidedAssistance = await NetworkServices().getProvidedAssistance();

      listProvidedAssistance = listProvidedAssistance
          .where((element) => element.appealData!.id == widget.appealInfo.id)
          .toList();

      List<ServiceData> temp = [];
      listService = await NetworkServices().getServices();

      listProvidedAssistance.forEach((assisntce) {
        temp.add(listService
            .where((element) =>
                element.id == assisntce.typeOfMedicalCareData!.serviceId)
            .single);
      });

      for (int index = 0; index < temp.length; index++) {
        _services =
            ('${_services.toString()} ${(temp[index].service).toString()}');
        if (index + 1 == temp.length) {
          _services = ('${_services.toString()}.');
        } else {
          _services = ('${_services.toString()}; ');
        }
      }
      setState(() {});
    }
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Подробности обращения',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(80, 72, 190, 48),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Дата первичного обращения: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.appealInfo.dateFirstAppealData!.dateFirstAppeal.toString()))} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Дата и время приема: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.appealInfo.dateOfRendering.toString()))} ${widget.appealInfo.scheduleData!.time} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Специальность врача: ${widget.appealInfo.medicalSpecialityData?.speciality ?? '*'} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Врач: ${widget.appealInfo.employeeData!.surname} ${widget.appealInfo.employeeData!.name} ${widget.appealInfo.employeeData!.patronymic} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Жалобы: ${widget.appealInfo.complaints ?? ''} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Осмотр: ${widget.appealInfo.inspection ?? ''} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Диагноз: ${widget.appealInfo.diagnosis ?? ''} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Рекомендции: ${widget.appealInfo.recommendations ?? ''} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              _services!.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Услуги: ${_services!} ',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
