import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';
import 'package:jourapothole/core/wrappers/body_wrapper.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyWrapper(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Login to your Account", style: AppTextStyles.headerLarge),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
