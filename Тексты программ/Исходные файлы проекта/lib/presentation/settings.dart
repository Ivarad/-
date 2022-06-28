import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pppd_project/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:pppd_project/presentation/change_password.dart';
import 'package:pppd_project/presentation/support.dart';
import 'package:pppd_project/presentation/app_info.dart';
// Класс создающий виджеты экрана настроек
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}
// Класс определяющий состояние виджетов
class _SettingsState extends State<Settings> {
// Функция возвращающая виджеты экрана
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Настройки',
            style: TextStyle(fontSize: 28),
          ),
          backgroundColor: const Color.fromARGB(80, 72, 190, 48),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoSwitch(
                      value: themeNotifier.isDark,
                      onChanged: (value) {
                        setState(() {
                          themeNotifier.isDark = value;
                        });
                      },
                    ),
                    const Text(
                      'Сменить тему приложения',
                      style: TextStyle(fontSize: 22),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.lock,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 40,
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(400),
                      primary: const Color.fromARGB(197, 77, 163, 51),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(authorizated: true,),
                      ),
                    );
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Смена пароля",
                      style: TextStyle(
                          fontSize: 28,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.support_agent_rounded,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 40,
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(430),
                      primary: const Color.fromARGB(197, 77, 163, 51),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Support(),
                      ),
                    );
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Техническая поддержка",
                      style: TextStyle(
                          fontSize: 28,
                          color: Color.fromARGB(255, 255, 255, 255)),
                          
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 40,
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(400),
                      primary: const Color.fromARGB(197, 77, 163, 51),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppInfo(),
                      ),
                    );
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "О приложении",
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
    });
  }
}
