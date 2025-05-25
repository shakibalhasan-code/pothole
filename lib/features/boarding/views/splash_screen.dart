import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/core/utils/routes/app_pages.dart';
import 'package:jourapothole/features/boarding/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.logoColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(AppImages.logo, width: 100.w, height: 100.h),
            ),
            SizedBox(height: 20.h),
            const CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
