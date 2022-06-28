import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pppd_project/models/appeals_data.dart';
import 'package:pppd_project/presentation/home.dart';
import 'package:pppd_project/models/theme_model.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pppd_project/helpers/authorizated.dart';
import 'package:pppd_project/presentation/patient_personal_area.dart';
import 'package:pppd_project/presentation/analyst_personal_area.dart';
import 'package:pppd_project/presentation/doctor_personal_area.dart';

// Начальный метод приложения
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await DesktopWindow.setMinWindowSize(const Size(500, 750));
      await DesktopWindow.setMaxWindowSize(const Size(1000, 750));
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  List<String> listdata = await Authorizated().getAuthorizated();
  runApp(Application(check: listdata[2] != 'null' ? listdata[2] : '-1'));
}

// Класс инициализирующий начальные значения в программе, и определяющий вызываемый экран
class Application extends StatelessWidget {
  const Application({Key? key, required this.check}) : super(key: key);

  final String
      check; // Переменная содержащая в себе роль авторизванного ранее пользователя
  // Функция определяющая экран предназначенный для роли пользователя
  dynamic checkData() {
    DesktopWindow.setWindowSize(const Size(1000, 750));
    if (check.isNotEmpty) {
      switch (int.parse(check)) {
        case 1:
          return PersonalAreaPatient(
            patientAndDoctor: true,
            appealPatient: AppealData(),
          );
        case 2:
          return const PersonalAreaDoctor();
        case 3:
          return const PersonalAreaAnalyst();
        default:
          return const Home();
      }
    }
  }

// Функция построения виджитов на экране
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ru', 'RU')
              ],
              title: 'Система УСОМП',
              theme:
                  themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
              debugShowCheckedModeBanner: false,
              home: checkData());
        }));
  }
}
