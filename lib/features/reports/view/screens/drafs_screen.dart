import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:jourapothole/core/models/draf_data_model.dart'; // Ensure this path is correct
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/reports/controllers/report_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_bottom_sheet.dart';

class DrafsScreen extends StatelessWidget {
  DrafsScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();

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
        title: Text(
          'Draft Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Obx(() {
        // Use the loading state from the controller if available
        if (homeController.isLoadingDrafts.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final draftReportsList = homeController.draftReports;
        if (draftReportsList.isEmpty) {
          return const Center(
            child: Text(
              'No draft reports found.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          scrollDirection: Axis.vertical,
          itemCount: draftReportsList.length,
          itemBuilder: (context, index) {
            final draft = draftReportsList[index];
            return _buildDynamicDraftCard(context, draft, homeController);
          },
        );
      }),
    );
  }

  Widget _buildDynamicDraftCard(
    BuildContext context,
    DrafDataModel draft,
    HomeController controller, // Pass the controller for delete action
  ) {
    DateTime dateTime = DateTime.tryParse(draft.time!) ?? DateTime.now();
    // Displaying time as "12:30 PM"
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return InkWell(
      onTap: () async {
        Get.find<LocationServices>().userCurrentLocation.value = draft.address;
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h), // Spacing between cards
        child: Container(
          constraints: BoxConstraints(minHeight: 64.h), // Minimum height
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(
              width: 1,
              color: AppColors.primaryLightColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.blueColor,
                size: 22,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      draft.address.isNotEmpty
                          ? draft.address
                          : 'Lat: ${draft.latitude.toStringAsFixed(3)}, Lng: ${draft.longitude.toStringAsFixed(3)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2, // Allow up to 2 lines for address
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Time: $formattedTime', // Using the formatted time
                      style: TextStyle(
                        color: Colors.black54, // Softer color for time
                        fontSize: 12.sp,
                        // fontWeight: FontWeight.bold, // As per original
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w), // Space before delete icon
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.redColor,
                  size: 24,
                ),
                padding: EdgeInsets.zero, // Remove default padding
                constraints:
                    BoxConstraints(), // Remove default constraints for denser layout
                onPressed: () {
                  Get.defaultDialog(
                    title: "Delete Draft",
                    middleText: "Are you sure you want to delete this draft?",
                    titleStyle: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    middleTextStyle: TextStyle(fontSize: 14.sp),
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    buttonColor: AppColors.redColor,
                    confirmTextColor: Colors.white,
                    cancelTextColor: AppColors.blueColor,
                    onConfirm: () {
                      if (draft.id != null) {
                        controller.deleteDraft(draft.id!);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Cannot delete draft without ID.",
                        );
                      }
                      Get.back(); // Close dialog
                    },
                    onCancel: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
