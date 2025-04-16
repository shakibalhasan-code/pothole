import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;
  final PageController pageController = PageController();

  void changePage(int index) {
    if (index != 2) {
      // Skip the FAB index
      selectedIndex.value = index > 2 ? index - 1 : index;
      pageController.jumpToPage(selectedIndex.value);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
