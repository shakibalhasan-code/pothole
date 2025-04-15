import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_text_styles.dart';

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
