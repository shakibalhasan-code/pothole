import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/core/utils/constants/app_images.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_details.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text('Reports'),
        automaticallyImplyLeading: false, // Remove back button if not needed
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Expanded(
          // Use Obx to react to changes in allPothole or isLoading
          child: Obx(() {
            // Show loading indicator while fetching
            if (homeController.isLoading.value) {
              return const Center(child: CupertinoActivityIndicator());
            }
            // Show a message if the list is empty after loading
            else if (homeController.allPothole.isEmpty) {
              return const Center(
                child: Text(
                  'No reports found.',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
            // Show the list if data is available
            else {
              return ListView.builder(
                // Use the actual number of items in the list
                itemCount: 3,
                itemBuilder: (context, index) {
                  // Get the PotholeModel for the current item
                  final potholeReport = homeController.allPothole[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5.h,
                    ), // Assuming .h is from a size utility
                    child: _buildReportCard(
                      potholeReport.issue,
                      potholeReport.location.address,
                      potholeReport.status,
                      potholeReport.status == 'open'
                          ? Colors.red
                          : Colors.green,
                      (potholeReport.images != null &&
                              potholeReport.images.isNotEmpty)
                          ? potholeReport.images[0]
                          : 'https://placehold.co/600x400', // fallback image
                      () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.whiteColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder:
                              (context) => ReportProblemBottomSheet(
                                report: potholeReport,
                              ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String issueType,
    String location,
    String status,
    Color statusColor,
    String image,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightBlueColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.greyColor.withOpacity(0.3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  filterQuality: FilterQuality.none,
                  image ?? 'https://placehold.co/600x400',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ), // Replace with actual image
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Issue type: $issueType',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.blueColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Issue Update:',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
