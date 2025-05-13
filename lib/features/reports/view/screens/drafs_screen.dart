import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/features/reports/controllers/report_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';

class DrafsScreen extends StatelessWidget {
  DrafsScreen({super.key});
  final reportController = Get.find<ReportController>();

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
      body: Obx(() {
        final draftReports = reportController.draftReports;
        if (draftReports.isEmpty) {
          return Center(child: Text('No locations saved.'));
        }
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: draftReports.length,
          itemBuilder: (context, index) {
            final location = draftReports[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ), // Add spacing between list items
              child: Card(
                elevation: 4.0, // Optional: Add card elevation for better UI
                child: ListTile(
                  title: Text(location.address),
                  subtitle: Text(
                    'Lat: ${location.latitude}, Long: ${location.longitude}, Time: ${location.time}',
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  InkWell drafReportWidget(BuildContext context) {
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
            border: Border.all(width: 1, color: AppColors.primaryLightColor),
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
  }
}
