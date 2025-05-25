import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jourapothole/core/utils/components/custom_button.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';

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

  static Future<void> showDeleteAccountModalSheet(
    BuildContext context,
    String id, {
    String title = 'Delete Account',
    String content =
        'Are you sure you want to delete your account? This action cannot be undone.',
    String additionalInfo =
        'Once done, your data cannot be recovered. All associated information will be permanently removed.',
    String cancelText = 'Cancel',
    String deleteText = 'Delete',
    Color titleColor = AppColors.redColor,
    Color contentColor = Colors.black,
    Color additionalInfoColor = Colors.black54,
    Color cancelTextColor = Colors.blue,
    Color deleteTextColor = AppColors.redColor,
    double titleFontSize = 22.0,
    double contentFontSize = 18.0,
    double additionalInfoFontSize = 16.0,
    double buttonFontSize = 16.0,
    double borderRadius = 24.0,
    Color modalBackgroundColor = Colors.white,
    Color textBackgroundColor = const Color(
      0xFFE3F2FD,
    ), // Light blue "cool" background for text
    VoidCallback? onDelete, // Optional callback for delete action
  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius.r),
        ),
      ),
      backgroundColor: modalBackgroundColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: titleColor,
                  fontSize: titleFontSize.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: textBackgroundColor, // Cool background for text
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: contentColor,
                        fontSize: contentFontSize.sp,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      additionalInfo,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: additionalInfoColor,
                        fontSize: additionalInfoFontSize.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      cancelText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: cancelTextColor,
                        fontSize: buttonFontSize.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  TextButton(
                    onPressed: () {
                      onDelete?.call(); // Execute custom delete logic
                      Navigator.pop(context);
                    },
                    child: Text(
                      deleteText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: deleteTextColor,
                        fontSize: buttonFontSize.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
