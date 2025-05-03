import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';

class DrafsScreen extends StatelessWidget {
  const DrafsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: const Text('Drafts Reports'),
      ),
      body: ListView.builder(
        itemCount: 10,

        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.whiteColor,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const PotholeReportBottomSheet(),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Container(
                height: 64.h,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(
                    width: 1,
                    color: AppColors.primaryLightColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.blueColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2972 Westheimer Rd. Santa Ana'),
                          SizedBox(height: 4),
                          Text(
                            'Time: 12.30 pm',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
