import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';
import 'package:jourapothole/core/helpers/input_validators.dart';

class CustomInputField extends StatelessWidget {
  CustomInputField({
    super.key,
    required this.controller,
    this.isEmail = false,
    this.isPassword = false,
    this.title,
    this.prefixIcon,
    this.maxLines = 1,
  });

  final String? title;
  final bool isEmail;
  final bool isPassword;
  final String? prefixIcon;
  final int maxLines;
  final TextEditingController controller;

  // To track obscure and unobsure state of password text
  final RxBool isObscure = true.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // the title with the sizedbox will only be rendered when it is provided
        if (title != null) Text(title!, style: AppTextStyles.bodyMedium),
        if (title != null) SizedBox(height: 8.h),
        // To design the text field container is used
        Obx(() {
          final obscure = isObscure.value;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryLightColor),
            ),
            // Row is used for prefix icons and suffix icons
            child: Row(
              crossAxisAlignment:
                  maxLines == 1
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                if (prefixIcon != null)
                  SvgPicture.asset(prefixIcon!, height: 20.h, width: 20.w),
                if (prefixIcon != null) SizedBox(width: 12.w),
                Flexible(
                  child: TextFormField(
                    // To remove default styling and setting hint text
                    decoration: InputDecoration(
                      hintText: "Enter your $title...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),

                    obscureText: isPassword ? obscure : false,

                    //  The maxlines determines the number of lines that can occupy the field
                    maxLines: maxLines,
                    // This is to validate fields based conditions
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // if the value of field is empty
                        return "This field cannot be empty";
                      }
                      if (isEmail) {
                        if (!InputValidators.isValidEmail(value)) {
                          // if email and not validated then the following the error will be shown
                          return "Please Enter valid $value";
                        }
                      }
                      if (isPassword) {
                        if (value.length < 8) {
                          // password validating on length
                          return "Please Enter valid $value";
                        }
                      }
                      // default return of null
                      return null;
                    },
                  ),
                ),
                // for obscure and unobscure text
                if (isPassword) SizedBox(width: 12.h),
                if (isPassword)
                  Obx(() {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        isObscure.value = !isObscure.value;
                      },
                      child: Icon(
                        isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.sp,
                      ),
                    );
                  }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
