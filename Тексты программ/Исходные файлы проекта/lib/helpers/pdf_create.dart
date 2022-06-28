import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:pppd_project/models/provided_assistance_data.dart';
import 'package:pppd_project/models/type_of_medical_care_data.dart';

// Класс создания PDF документа
class PDFCreate {
  // Функция создающая структуру PDF документа и наполняющая его данными
  static Future<File> generateCenteredText(
      List<ProvidedAssistanceData> listAssistances,
      List<TypeOfMedicalCareData> listServices,
      String nameDocument) async {
    WidgetsFlutterBinding.ensureInitialized();
    var data = await rootBundle.load('assets/Times_New_Roman.ttf');
    var fontTimes = pw.Font.ttf(data);

    final pdf = pw.Document();
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
    pdf.addPage(
      pw.Page(
          build: (context) => pw.Center(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: <pw.Widget>[
                    pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 50),
                        child: pw.Text('Стастистика оказанных услуг',
                            textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(font: fontTimes, fontSize: 30))),
                    pw.Expanded(
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Table(children: [
                              pw.TableRow(children: [
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 250,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Тип мед помощи',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      )
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 200,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Услуга',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      )
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 100,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Оказана',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      )
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 100,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Цена',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      )
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 100,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Затраты',
                                            maxLines: 100,
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      )
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 100,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Прибыль',
                                            maxLines: 100,
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      )
                                    ]),
                              ]),
                            ]),
                            pw.Table(children: [
                              for (var i = 0; i < listServices.length; i++)
                                pw.TableRow(children: [
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Container(
                                          width: 250,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: pw.Text(
                                              '${listServices[i].typeOfMedicalCare}',
                                              maxLines: 100,
                                              style: pw.TextStyle(
                                                  font: fontTimes,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Container(
                                          width: 200,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: pw.Text(
                                              '${listServices[i].serviceData!.service}',
                                              maxLines: 100,
                                              style: pw.TextStyle(
                                                  font: fontTimes,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Container(
                                          width: 100,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: pw.Text(
                                              '${listAssistances.where((element) => element.serviceData!.service == listServices[i].serviceData!.service).length}',
                                              maxLines: 100,
                                              style: pw.TextStyle(
                                                  font: fontTimes,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Container(
                                          width: 100,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: pw.Text(
                                              '${listServices[i].priceData!.price}',
                                              maxLines: 100,
                                              style: pw.TextStyle(
                                                  font: fontTimes,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Container(
                                          width: 100,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: pw.Text(
                                              '${listServices[i].incomesAndExpensesData!.expenses}',
                                              maxLines: 100,
                                              style: pw.TextStyle(
                                                  font: fontTimes,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Container(
                                          width: 100,
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: pw.Text(
                                              '${listServices[i].incomesAndExpensesData!.income}',
                                              maxLines: 100,
                                              style: pw.TextStyle(
                                                  font: fontTimes,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                ])
                            ]),
                            pw.Container(height: 100),
                            pw.Table(children: [
                              pw.TableRow(children: [
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 250,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Итоговые затрты',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      ),
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 250,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('Итоговая прибыль',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      ),
                                    ]),
                              ]),
                              pw.TableRow(children: [
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 250,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('$totalExpenses',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      ),
                                    ]),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        width: 250,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.black),
                                        ),
                                        child: pw.Text('$totalIncome',
                                            style: pw.TextStyle(
                                                font: fontTimes, fontSize: 14)),
                                      ),
                                    ]),
                              ]),
                            ]),
                          ]),
                    ),
                  ]))),
    );

    return saveDocument(name: '$nameDocument.pdf', pdf: pdf);
  }

  // Функция сохранения файла
  static Future<File> saveDocument({
    String? name,
    pw.Document? pdf,
  }) async {
    final bytes = await pdf!.save();
    String nameNow = name!;
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$nameNow');
    if (await File('${dir.path}/$nameNow').exists()) {
      nameNow = '${name.substring(0, name.lastIndexOf('.'))} copy .pdf';
      file = File('${dir.path}/$nameNow');
    }
    await file.writeAsBytes(bytes);
    return file;
  }

// Метод открывающий созданный файл
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
