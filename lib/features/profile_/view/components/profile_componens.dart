import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/components/custom_button.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';

class ProfileComponents {
  static Future<void> showLogOutSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Logout',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.redColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Divider(thickness: 1, color: AppColors.lightGrayColor),
              SizedBox(height: 15.h),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.black,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue), // Blue outline
                        backgroundColor: Colors.white, // White background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            24.r,
                          ), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.blue, // Blue text
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomButton(
                      buttonTitle: 'Continue',
                      onTap: () {
                        // Handle logout logic here
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
