import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.primaryLightColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.grayColor),
        filled: false,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white, // AppBar background color
        elevation: 3, // Slight elevation for shadow
        shadowColor: Colors.blue.withOpacity(
          0.4,
        ), // Blue shadow as seen in the image
        foregroundColor: Colors.black, // Text and icon color
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.grey, // For icons like the notification bell
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
