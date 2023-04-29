import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Quick {
  static costumDialogue(
      String title, BuildContext context, QuickAlertType name) {
    return QuickAlert.show(
      context: context,
      type: name,
      title: title,
      backgroundColor: Colors.grey.shade700,
      titleColor: Colors.white,
    );
  }
}
