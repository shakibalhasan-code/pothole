import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jourapothole/features/home/views/home_view.dart';
import 'package:jourapothole/features/main_tab/components/custom_bottom_nav.dart';
import 'package:jourapothole/features/main_tab/controller/bottom_nav_controller.dart';
import 'package:jourapothole/features/map/view/screens/map_screen.dart';
import 'package:jourapothole/features/profile_/view/screens/profile_screen.dart';
import 'package:jourapothole/features/reports/view/screens/reports_screen.dart';

class MainParentScreen extends StatelessWidget {
  const MainParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return Scaffold(
      body: PageView(
        controller: controller.pageController,

        onPageChanged: controller.onPageChanged,
        children: [HomeView(), MapScreen(), ReportsScreen(), ProfileScreen()],
      ),

      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
