import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jourapothole/core/utils/routes/app_pages.dart';
import 'package:jourapothole/features/boarding/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.r),
            decoration: const BoxDecoration(
              color: Color(0xff096DE2),
              shape: BoxShape.circle,
            ),
            child: Text(
              "JP",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 60.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
