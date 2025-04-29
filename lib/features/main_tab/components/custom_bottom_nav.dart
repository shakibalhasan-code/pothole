import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_icons.dart';
import 'package:jourapothole/features/main_tab/controller/bottom_nav_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find();

    return Obx(
      () => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(AppIcons.homeIcon, 'Home', 0, controller),
              _buildNavItem(AppIcons.mapIcon, 'Map', 1, controller),
              InkWell(
                splashColor: Colors.white24,
                borderRadius: BorderRadius.circular(10.r),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.whiteColor,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const PotholeReportBottomSheet(),
                  );
                },
                child: Container(
                  width: 48.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
              _buildNavItem(AppIcons.reportsIcon, 'Reports', 3, controller),
              _buildNavItem(AppIcons.personIcon, 'Profile', 4, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String icon,
    String label,
    int index,
    BottomNavController controller,
  ) {
    final isSelected =
        controller.selectedIndex.value == (index > 2 ? index - 1 : index);
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => controller.changePage(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
