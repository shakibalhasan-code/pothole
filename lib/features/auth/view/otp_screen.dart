import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jourapothole/core/utils/components/custom_button.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';
import 'package:jourapothole/features/auth/view/new_password_screen.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  final bool isForgetPass;
  OtpScreen({super.key, required this.email, required this.isForgetPass});
  final authContrller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text('Verify'),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Code has been send to $email',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: OtpTextField(
                      fieldHeight: 61.h,
                      fieldWidth: 71.w,
                      numberOfFields: 4,
                      borderColor: Color.fromARGB(255, 34, 31, 41),
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                        authContrller.otp.value = code;
                      },
                      //runs when every textfield is filled
                      // onSubmit: (String verificationCode) async {
                      //   authContrller.otpController.text = verificationCode;
                      //   await authContrller.verifyOtp(
                      //     email,
                      //     verificationCode,
                      //     isForgetPass,
                      //   );
                      // }, // end onSubmit
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 180.h),
            Obx(() {
              return authContrller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                    buttonTitle: 'Continue',
                    onTap: () {
                      authContrller.verifyOtp();
                    },
                  );
            }),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
