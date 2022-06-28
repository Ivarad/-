import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pppd_project/helpers/message.dart';

// Класс проверки подключения к сети
class CheckNetwork {
  // Фукнция проверки подключения к сети
  Future<bool> checkConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      Message().message('Проверьте подключение к интернету', context);
      return false;
    }
  }
}
