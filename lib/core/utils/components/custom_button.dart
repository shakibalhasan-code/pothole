import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonTitle,
    required this.onTap,
    this.isRounded = true,
    this.isFilled = true,
    this.isRed = false,
    this.widthFactor = 1,
  });

  final VoidCallback onTap;
  final String buttonTitle;
  final bool isRounded;
  final bool isFilled;
  final bool isRed;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: (isFilled && !isRed) ? AppColors.primaryColor : null,
            border: Border.all(
              color: isRed ? AppColors.dangerColor : AppColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(isRounded ? 100 : 12),
          ),
          child: Center(
            child: Text(
              buttonTitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color:
                    isFilled
                        ? AppColors.whiteColor
                        : isRed
                        ? AppColors.dangerColor
                        : AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
