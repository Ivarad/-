import 'package:flutter/material.dart';

// Класс сообщения пользователю
class Message {
  //Метод сообщения
  message(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
