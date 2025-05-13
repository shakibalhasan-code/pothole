import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';

class AuthCard extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  const AuthCard({super.key, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(width: 1, color: AppColors.lightGrayColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(iconPath, width: 24.w, height: 24.h),
        ),
      ),
    );
  }
}
