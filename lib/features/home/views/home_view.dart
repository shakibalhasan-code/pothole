import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:jourapothole/core/models/draf_data_model.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/core/utils/components/app_bar.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
// import 'package:jourapothole/core/utils/constants/app_images.dart'; // Not used in this snippet
// import 'package:jourapothole/core/utils/helper/db_helper.dart'; // Not directly used here
import 'package:jourapothole/features/glob_widgets/my_map_widget.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/main_tab/controller/bottom_nav_controller.dart';
// import 'package:jourapothole/features/reports/controllers/report_controller.dart'; // Not directly used here
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';
import 'package:jourapothole/features/reports/view/components/reports_details.dart'; // For ReportProblemBottomSheet
import 'package:jourapothole/features/reports/view/screens/drafs_screen.dart'; // Corrected typo: DrafsScreen
// Make sure this import exists and PotholeReportModel is correctly defined
// import 'package:jourapothole/core/models/pothole_report_model.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final navController = Get.find<BottomNavController>();
  final homeController = Get.put(HomeController());
  final locat = Get.find<LocationServices>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: GlobalAppBar(
        actionChildren: const SizedBox.shrink(),
        isShowProfile: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: MyMapWidget(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.whiteColor,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const PotholeReportBottomSheet(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Report a Pothole',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final String address =
                          locat.userCurrentLocation.value.isNotEmpty
                              ? locat.userCurrentLocation.value
                              : "Unknown Address";
                      final double latitude = locat.latt;
                      final double longitude = locat.long;
                      final String currentTime =
                          DateTime.now().toIso8601String();

                      if (latitude == 0.0 &&
                          longitude == 0.0 &&
                          address == "Unknown Address") {
                        Get.snackbar(
                          "Location Error",
                          "Could not get current location. Ensure services are enabled.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      DrafDataModel newDraft = DrafDataModel(
                        address: address,
                        latitude: latitude,
                        longitude: longitude,
                        time: currentTime,
                      );
                      await homeController.addQuickReport(newDraft);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.redColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Quick Report',
                      style: TextStyle(color: AppColors.redColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Draft Reports',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => Get.to(() => DrafsScreen()),
                  child: const Text(
                    'SEE ALL',
                    style: TextStyle(color: AppColors.blueColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (homeController.isLoadingDrafts.value) {
                return const Center(child: CupertinoActivityIndicator());
              }
              if (homeController.draftReports.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text('No draft reports found.'),
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      homeController.draftReports
                          .take(3) // Show latest 3, for example
                          .map(
                            (draft) => _buildDynamicDraftCard(
                              // Using the new method
                              context,
                              draft,
                              homeController,
                            ),
                          )
                          .toList(),
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Reports',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    navController.changePage(3);
                  },
                  child: const Text(
                    'SEE ALL',
                    style: TextStyle(color: AppColors.blueColor),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (homeController.allPothole.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recent reports found.',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  // Use ListView.builder for a scrollable vertical list
                  return ListView.builder(
                    itemCount: homeController.allPothole.length,
                    itemBuilder: (context, index) {
                      // Correct itemBuilder signature
                      final potholeReport = homeController.allPothole[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 5.h,
                          bottom: 5.h,
                        ), // Added bottom padding for spacing
                        child: _buildReportCard(
                          context,
                          potholeReport.issue,
                          potholeReport.location.address,
                          potholeReport.status,
                          potholeReport.status == 'open'
                              ? Colors.red
                              : Colors.green,
                          (potholeReport.images != null &&
                                  potholeReport
                                      .images!
                                      .isNotEmpty) // Added null check for potholeReport.images
                              ? potholeReport.images![0]
                              : 'https://placehold.co/600x400',
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
          ],
        ),
      ),
    );
  }

  // This widget is based on your drafReportWidget structure
  Widget _buildDynamicDraftCard(
    BuildContext context,
    DrafDataModel draft,
    HomeController controller,
  ) {
    DateTime dateTime = DateTime.tryParse(draft.time!) ?? DateTime.now();
    // User requested only time, e.g., "12:30 PM"
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: InkWell(
        onTap: () async {
          Get.find<LocationServices>().userCurrentLocation.value =
              draft.address;
          Get.find<LocationServices>().latt = draft.latitude;
          Get.find<LocationServices>().long = draft.longitude;

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
        child: Container(
          // height: 64.h, // You can set a fixed height or let it be dynamic
          constraints: BoxConstraints(minHeight: 65.h),
          width: 260.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(width: 1, color: AppColors.primaryLightColor),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.blueColor,
                size: 20,
              ), // Slightly smaller icon
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      draft.address.isNotEmpty
                          ? draft.address
                          : "Address not available",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Time: $formattedTime',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        // fontWeight: FontWeight.bold, // As per your original styling
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.redColor,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints:
                    BoxConstraints(), // To remove extra padding around IconButton
                onPressed: () {
                  Get.defaultDialog(
                    title: "Delete Draft",
                    middleText: "Are you sure you want to delete this draft?",
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      if (draft.id != null) {
                        controller.deleteDraft(draft.id!);
                      }
                      Get.back(); // Close dialog
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Your existing _buildReportCard
  Widget _buildReportCard(
    BuildContext context,
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
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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

// Make sure you have your PotholeReportModel defined correctly if it's used.
// For example:
/*
class PotholeReportModel {
  final String id;
  final String issue;
  final PotholeLocation location;
  final String status;
  final List<String> images;

  PotholeReportModel({
    required this.id,
    required this.issue,
    required this.location,
    required this.status,
    required this.images,
  });
}

class PotholeLocation {
  final String address;
  // other location fields if needed
  PotholeLocation({required this.address});
}
*/
