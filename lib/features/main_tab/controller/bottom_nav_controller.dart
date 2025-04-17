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

  // Call this method from PageView's onPageChanged
  void onPageChanged(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value =
          index; // Update index if page was changed by swiping
    }
  }

  @override
  void onClose() {
    pageController
        .dispose(); // Dispose the controller when GetX controller closes
    super.onClose();
  }
}
