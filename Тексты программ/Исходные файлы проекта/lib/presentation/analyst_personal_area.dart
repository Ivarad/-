import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:pppd_project/helpers/check_network.dart';
import 'package:pppd_project/helpers/message.dart';
import 'package:pppd_project/helpers/network_services.dart';
import 'package:pppd_project/helpers/excel_create.dart';
import 'package:pppd_project/models/provided_assistance_data.dart';
import 'package:pppd_project/models/type_of_medical_care_data.dart';
import 'package:pppd_project/presentation/settings.dart';
import 'package:pppd_project/presentation/home.dart';
import 'package:pppd_project/helpers/pdf_create.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pppd_project/helpers/authorizated.dart';

// Класс создающий виджеты экрана личного кабинете аналитика
class PersonalAreaAnalyst extends StatefulWidget {
  const PersonalAreaAnalyst({Key? key}) : super(key: key);

  @override
  State<PersonalAreaAnalyst> createState() => _PersonalAreaAnalystState();
}

class _PersonalAreaAnalystState extends State<PersonalAreaAnalyst> {
  // Лист оказанных услуг и мед помощи
  List<ProvidedAssistanceData> listProvided = [];
  // Лист отфильтрованных, оказанных услуг и мед помощи
  List<ProvidedAssistanceData> filteredListProvided = [];
  // Лист видов мед помощи
  List<TypeOfMedicalCareData> listCares = [];
  // Лист отфильтрованных видов мед помощи
  List<TypeOfMedicalCareData> filteredListCares = [];

  String? _documentName =
      ''; // Переменная содержащая значение наименования документа
  final _formKey = GlobalKey<
      FormState>(); // Переменная принимающая ключ проверки валидации полей
  Map<String, double> dataMap =
      {}; // Коллекция содержащая услуги, мед помощь и количетсво раз оказания
  // Лист фильтр содеражащий временные промежутки для фильрации данных по времени
  List<String> filter = [
    'За неделю',
    'За месяц',
    'За полгода',
    'За год',
    'Настраиваемый диапазон'
  ];
  String? dropdownValue =
      'За неделю'; // Переменная содержащая значение выбранного в списке временного промежутка

  bool _isServicesLoading =
      false; // Переменная содержащая значение соответствующее получению данных
  // Переменная содержащая значение временного промежутка
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
    end:
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );
// Переменная содержащая значение начальной даты
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);
  // Переменная содержащая значение конечной даты
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  // Метод инициализрующий значения при первом запуске экрана
  @override
  void initState() {
    super.initState();
    filterServices(
        DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
    setState(() {});
  }

// Метод вызывающий виджет DateRangePicker для выбора нужного диапазона дат
  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1970),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    setState(() {
      dateRange = newDateRange ?? dateRange;
    });
  }

// Метод фильтрующий лист оказанных услуг и мед помощи, по временному диапазону
  filterServices(DateTime startDate, DateTime endDate) async {
    if (await CheckNetwork().checkConnection(context)) {
      Map<String, double> tempDataMap = {};

      _startDate = startDate;
      _endDate = endDate;

      _isServicesLoading = true;
      await getServicesAndAssiatance();
      filteredListCares = listCares;
      filteredListProvided = listProvided
          .where((provided) =>
              (startDate.isBefore(DateTime.parse(
                      provided.appealData!.dateOfRendering.toString())) ||
                  startDate.isAtSameMomentAs(DateTime.parse(
                      provided.appealData!.dateOfRendering.toString()))) &&
              (endDate.isAfter(DateTime.parse(
                      provided.appealData!.dateOfRendering.toString())) ||
                  endDate.isAtSameMomentAs(DateTime.parse(
                      provided.appealData!.dateOfRendering.toString()))))
          .toList();

      filteredListCares.forEach((element) {
        tempDataMap.putIfAbsent(
            element.serviceData!.service.toString(),
            () => listProvided
                .where((provided) =>
                    provided.serviceData!.service == element.serviceData!.service &&
                    (startDate.isBefore(DateTime.parse(
                            provided.appealData!.dateOfRendering.toString())) ||
                        startDate.isAtSameMomentAs(DateTime.parse(provided
                            .appealData!.dateOfRendering
                            .toString()))) &&
                    (endDate.isAfter(DateTime.parse(provided.appealData!.dateOfRendering.toString())) ||
                        endDate.isAtSameMomentAs(DateTime.parse(
                            provided.appealData!.dateOfRendering.toString()))))
                .length
                .toDouble());
      });
      dataMap = tempDataMap;
      _isServicesLoading = false;

      setState(() {});
    }
  }

// Метод обрабатывающий выбранное значение в списке и вызывающий метод фильтрации данных
  selectedDate() async {
    switch (dropdownValue) {
      case 'За неделю':
        filterServices(
            DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
        break;
      case 'За месяц':
        filterServices(
            DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day),
            DateTime.now());
        break;
      case 'За полгода':
        filterServices(
            DateTime(DateTime.now().year, DateTime.now().month - 6,
                DateTime.now().day),
            DateTime.now());
        break;
      case 'За год':
        filterServices(
            DateTime(DateTime.now().year - 1, DateTime.now().month,
                DateTime.now().day),
            DateTime.now());
        break;
      case 'Настраиваемый диапазон':
        await pickDateRange();
        filterServices(dateRange.start, dateRange.end);
        break;
      default:
        filterServices(
            DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
        break;
    }
  }

  // Метод наполняющий данными листы оказанных услуг и мед помощи, видов мед помощи
  Future getServicesAndAssiatance() async {
    listProvided = await NetworkServices().getProvidedAssistance();
    listCares = await NetworkServices().getMedicalCares();
  }

// Метод вызывающий диалоговое окно (виджет AlertDialog) для формирования документации
  showAlertDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: const Text("Формирование документации"),
      content: const Text(
          "Введеите наименование документа и выберите тип документа"),
      actions: [
        Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Введите наименование документа",
                labelText: "Наименование документа",
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
                _documentName = value;
              },
              validator: (value) {
                if (value!.trim() == '') {
                  return 'Заполните поле наименования документа!';
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  child: const Text("Отмена"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  child: const Text("PDF"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final pdfFile = await PDFCreate.generateCenteredText(
                          filteredListProvided,
                          filteredListCares,
                          _documentName!);

                      PDFCreate.openFile(pdfFile);
                      Navigator.of(context).pop();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  child: const Text("Excel"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final excelFile = await ExcelCreate.generateExcelData(
                            _documentName!,
                            filteredListProvided,
                            filteredListCares);

                        ExcelCreate.openFile(excelFile);
                      } catch (e) {
                        Message()
                            .message('Закройте открытый файл Excel', context);
                      }

                      Navigator.of(context).pop();
                    }
                  }),
            ),
          ],
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 77, 163, 51),
          ),
          alignment: Alignment.centerRight,
        ),
        onPressed: () async {
          if (!_isServicesLoading &&
              filteredListProvided.isNotEmpty &&
              filteredListCares.isNotEmpty) {
            showAlertDialog(context);
          }
        },
        child: const Text(
          'Создать документ',
          style: TextStyle(fontSize: 28),
        ),
      ),
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
        children: <Widget>[
          DropdownButton<String>(
            items: filter.map((String singleItem) {
              return DropdownMenuItem<String>(
                  value: singleItem, child: Text(singleItem));
            }).toList(),
            onChanged: (String? itemChosen) {
              setState(() {
                dropdownValue = itemChosen;
                _isServicesLoading = true;
              });
              selectedDate();
            },
            value: dropdownValue,
          ),
          _isServicesLoading || dataMap.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[CircularProgressIndicator()],
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 2.2,
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: filteredListCares.isNotEmpty
                            ? filteredListCares.length
                            : 0,
                        itemBuilder: (BuildContext contextm, int index) {
                          return Center(
                            child: Container(
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
                                  'Вид мед помощи: ${filteredListCares[index].typeOfMedicalCare}\n' +
                                      'Услуга: ${filteredListCares[index].serviceData!.service}\n' +
                                      'Оказана: ${listProvided.where((provided) => provided.serviceData!.service == filteredListCares[index].serviceData!.service && (_startDate.isBefore(DateTime.parse(provided.appealData!.dateOfRendering.toString())) || _startDate.isAtSameMomentAs(DateTime.parse(provided.appealData!.dateOfRendering.toString()))) && (_endDate.isAfter(DateTime.parse(provided.appealData!.dateOfRendering.toString())) || _endDate.isAtSameMomentAs(DateTime.parse(provided.appealData!.dateOfRendering.toString())))).length}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                ),
        ],
      )),
    );
  }
}
