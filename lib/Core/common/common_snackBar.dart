import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController costumSnackbar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    colorText: Colors.white,
    backgroundColor: Colors.black,
    duration: const Duration(seconds: 5),
    icon: const Icon(
      Icons.warning_amber,
      color: Colors.white,
    ),
  );
}
