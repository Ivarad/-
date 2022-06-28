import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pppd_project/models/provided_assistance_data.dart';
import 'dart:io';
import 'package:pppd_project/models/type_of_medical_care_data.dart';

//Класс создания Excel файла
class ExcelCreate {
  // Функция создающая структуру Excel документа и наполняющая его данными
  static Future<File> generateExcelData(
      String nameDocument,
      List<ProvidedAssistanceData> listAssistances,
      List<TypeOfMedicalCareData> listServices) async {
    var excel = Excel.createExcel();

    double totalIncome = 0, totalExpenses = 0;
    listServices.forEach((service) {
      totalExpenses += double.parse(
              service.incomesAndExpensesData!.expenses.toString()) *
          listAssistances
              .where((element) =>
                  element.serviceData!.service == service.serviceData!.service)
              .length;
      totalIncome += double.parse(
              service.incomesAndExpensesData!.income.toString()) *
          listAssistances
              .where((element) =>
                  element.serviceData!.service == service.serviceData!.service)
              .length;
    });

    CellStyle cellStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Arial),
    );

    var sheet = excel['Sheet1'];
    sheet.cell(CellIndex.indexByString("A1")).value =
        'Статистика оказанных услуг';
    sheet.cell(CellIndex.indexByString("A2")).value = 'Тип мед помощи';
    sheet.cell(CellIndex.indexByString("B2")).value = 'Услуга';
    sheet.cell(CellIndex.indexByString("C2")).value = 'Оказана';
    sheet.cell(CellIndex.indexByString("D2")).value = 'Цена';
    sheet.cell(CellIndex.indexByString("E2")).value = 'Затраты';
    sheet.cell(CellIndex.indexByString("F2")).value = 'Прибыль';

    for (var i = 0; i < listServices.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 2))
          .value = listServices[i].typeOfMedicalCare;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 2))
          .value = listServices[i].serviceData!.service;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 2))
              .value =
          listAssistances
              .where((element) =>
                  element.serviceData!.service ==
                  listServices[i].serviceData!.service)
              .length;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 2))
          .value = listServices[i].priceData!.price;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 2))
          .value = listServices[i].incomesAndExpensesData!.expenses;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 2))
          .value = listServices[i].incomesAndExpensesData!.income;
    }
    sheet
        .cell(CellIndex.indexByColumnRow(
            columnIndex: 0, rowIndex: listServices.length + 4))
        .value = 'Итоговые затрты';
    sheet
        .cell(CellIndex.indexByColumnRow(
            columnIndex: 1, rowIndex: listServices.length + 4))
        .value = 'Итоговая прибыль';

    sheet
        .cell(CellIndex.indexByColumnRow(
            columnIndex: 0, rowIndex: listServices.length + 5))
        .value = totalExpenses;
    sheet
        .cell(CellIndex.indexByColumnRow(
            columnIndex: 1, rowIndex: listServices.length + 5))
        .value = totalIncome;

    return saveDocument(name: '$nameDocument.xlsx', excel: excel);
  }

  // Функция сохранения файла
  static Future<File> saveDocument({
    String? name,
    Excel? excel,
  }) async {
    final bytes = await excel!.save();
    String nameNow = name!;
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$name');
    if (await File('${dir.path}/$name').exists()) {
      nameNow = '${name.substring(0, name.lastIndexOf('.'))} copy .xlsx';
      file = File('${dir.path}/$name copy');
    }

    await file.writeAsBytes(bytes!);

    return file;
  }

// Метод открывающий созданный файл
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
