import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class GlobWidgetHelper {
  static void showToast({required bool isSuccess, required String message}) {
    Get.snackbar(
      isSuccess ? 'Sucess' : 'Failed',
      message,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 30,
    );
  }
}
