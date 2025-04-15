import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jourapothole/core/constants/app_colors.dart';
import 'package:jourapothole/core/constants/app_icons.dart';

class AuthCard extends StatelessWidget {
  final String iconPath;
  const AuthCard({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
