import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;
}
