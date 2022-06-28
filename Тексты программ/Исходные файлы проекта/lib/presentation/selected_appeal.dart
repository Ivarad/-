import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:pppd_project/models/provided_assistance_data.dart';
import 'package:pppd_project/models/type_of_medical_care_data.dart';
import 'package:pppd_project/presentation/doctor_personal_area.dart';

// Класс создающий виджеты экрана текущего обращения
class SelectedAppeal extends StatefulWidget {
  const SelectedAppeal({Key? key, required this.appealPatient})
      : super(key: key);

  final AppealData
      appealPatient; // Переменная параметр класса, которая содержит в себе данные обращения
  @override
  State<SelectedAppeal> createState() => _SelectedAppealState();
}

// Класс определяющий состояние виджетов
class _SelectedAppealState extends State<SelectedAppeal>
    with TickerProviderStateMixin {
  String? _complaints,
      _inspection,
      _diagnosis,
      _recommendations; // Переменные принимающие значения жалоб, осморта, диагноза, рекоммендаций

  final _formKey = GlobalKey<
      FormState>(); // Переменная принимающая ключ проверки валидации полей

  final List<String> servicesList = ['Выберите услугу']; // Лист услуг
  String? dropdownValue = 'Выберите услугу';
  List<ProvidedAssistanceData> listAssisnaces = []; // Лист оказанных услуг
  List<TypeOfMedicalCareData> listCares = []; // Лист типов мед помощи
  List<TypeOfMedicalCareData> listServicesRendered =
      []; // Лист определяющий оказанную мед помощь

  bool _isServicesLoading = false; // Переменная определяющая получение данных
  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    super.initState();
    _complaints = widget.appealPatient.complaints;
    _inspection = widget.appealPatient.inspection;
    _diagnosis = widget.appealPatient.diagnosis;
    _recommendations = widget.appealPatient.recommendations;
    _isServicesLoading = true;

    getAssistancesAndServices();
    setState(() {});
  }

// Метод наполняющий данными листы оказанных услуг и типов мед помощи
  Future getAssistancesAndServices() async {
    if (await CheckNetwork().checkConnection(context)) {
      listAssisnaces = await NetworkServices().getProvidedAssistance();
      listAssisnaces = listAssisnaces
          .where((element) =>
              element.servicesRenderedId == widget.appealPatient.id)
          .toList();

      listCares = await NetworkServices().getMedicalCares();
      listCares.forEach((element) =>
          servicesList.add(element.serviceData!.service.toString()));

      setState(() {});
      listServicesRendered = listCares;
      _isServicesLoading = false;
    }
  }

// Метод добавляющий к обращению оказанные услуги и данные жалоб, осмотра, диагноза, рекоммендаций
  Future setAppealDataAndAsisstances(bool closed) async {
    if (await CheckNetwork().checkConnection(context)) {
      try {
        await NetworkServices().clearAssistance(widget.appealPatient.id!);
      } catch (e) {
        print(e);
      }

      listAssisnaces.forEach((element) async {
        await NetworkServices()
            .createAssistance(providedAssistanceData: element);
      });

      AppealData updateAppeal = widget.appealPatient;

      updateAppeal.complaints = _complaints;
      updateAppeal.inspection = _inspection;
      updateAppeal.diagnosis = _diagnosis;
      updateAppeal.recommendations = _recommendations;
      updateAppeal.closed = closed;

      await NetworkServices()
          .editAppeal(appealInfo: updateAppeal, id: updateAppeal.id!);
    }
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Текущее обращение',
          style: TextStyle(fontSize: 24),
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
                      maxLength: 300,
                      minLines: 1,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        hintText: "Введите жалобы",
                        labelText: "Жалобы",
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
                      initialValue: widget.appealPatient.complaints,
                      onChanged: (value) {
                        _complaints = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле жалоб!';
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
                      maxLength: 300,
                      minLines: 1,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        hintText: "Введите результаты осмотра",
                        labelText: "Осмотр",
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
                      initialValue: widget.appealPatient.inspection,
                      onChanged: (value) {
                        _inspection = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле осмотра!';
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
                      maxLength: 300,
                      minLines: 1,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        hintText: "Введите диагноз",
                        labelText: "Диагноз",
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
                      initialValue: widget.appealPatient.diagnosis,
                      onChanged: (value) {
                        _diagnosis = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле диагноза!';
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
                      maxLength: 300,
                      minLines: 1,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        hintText: "Введите рекомендации",
                        labelText: "Рекомендации",
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
                      initialValue: widget.appealPatient.recommendations,
                      onChanged: (value) {
                        _recommendations = value;
                      },
                      validator: (value) {
                        if (value!.trim() == '') {
                          return 'Заполните поле рекомендации!';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        listAssisnaces.isNotEmpty ? listAssisnaces.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        background: Container(color: Colors.red),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            listAssisnaces.removeAt(index);
                          });
                        },
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            margin: const EdgeInsets.all(5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                listAssisnaces[index].serviceData != null
                                    ? listAssisnaces[index]
                                        .serviceData!
                                        .service
                                        .toString()
                                    : 'При получении данных возникла проблема',
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _isServicesLoading
                            ? const CircularProgressIndicator()
                            : DropdownButton<String>(
                                items: servicesList.map((String singleItem) {
                                  return DropdownMenuItem<String>(
                                      value: singleItem,
                                      child: Text(singleItem));
                                }).toList(),
                                onChanged: (String? itemChosen) {
                                  setState(() {
                                    dropdownValue = itemChosen;
                                  });
                                },
                                value: dropdownValue,
                              ),
                        RawMaterialButton(
                          onPressed: () {
                            if (!_isServicesLoading &&
                                dropdownValue != 'Выберите услугу') {
                              listAssisnaces.add(ProvidedAssistanceData(
                                  servicesRenderedId: widget.appealPatient.id,
                                  typeOfMedicalCareId: listCares
                                      .firstWhere((element) =>
                                          element.serviceData!.service ==
                                          dropdownValue.toString())
                                      .id,
                                  typeOfMedicalCareData: listCares.firstWhere(
                                      (element) =>
                                          element.serviceData!.service ==
                                          dropdownValue.toString()),
                                  serviceData: listCares
                                      .firstWhere((element) =>
                                          element.serviceData!.service ==
                                          dropdownValue.toString())
                                      .serviceData));
                              setState(() {
                                listServicesRendered.add(listCares.firstWhere(
                                    (element) =>
                                        element.serviceData!.service ==
                                        dropdownValue.toString()));
                              });
                            } else{
                              Message().message('Выберите услугу!', context);
                            }
                          },
                          elevation: 2.0,
                          fillColor: const Color.fromARGB(197, 77, 163, 51),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          shape: const CircleBorder(),
                        )
                      ],
                    ),
                  ),
                ],
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
                  if (_formKey.currentState!.validate()) {
                    if (await CheckNetwork().checkConnection(context)) {
                      setAppealDataAndAsisstances(true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalAreaDoctor(),
                        ),
                      );
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Закрыть обращение",
                    style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 255, 255, 255)),
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
                  if (_formKey.currentState!.validate()) {
                    if (await CheckNetwork().checkConnection(context)) {
                      await setAppealDataAndAsisstances(false);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalAreaDoctor(),
                        ),
                      );
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Внести данные",
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
