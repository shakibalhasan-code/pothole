import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jourapothole/core/models/profile_model.dart';
import 'package:jourapothole/core/utils/components/custom_button.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart';

class EditProfile extends StatelessWidget {
  final ProfileModel profileModel;

  EditProfile({super.key, required this.profileModel}) {
    final ProfileController controller = Get.find<ProfileController>();
    controller.initializeFields(profileModel);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name
            const Text(
              'First Name', // Changed from Nickname
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller:
                  controller.firstNameController, // Was nickNameController
              decoration: InputDecoration(
                hintText: 'Enter your First Name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name
            const Text(
              'Last Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.lastNameController, // New
              decoration: InputDecoration(
                hintText: 'Enter your Last Name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // // Date of Birth (Not updatable via this form as per backend schema)
            // const Text(
            //   'Date of Birth',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            // ),
            // const SizedBox(height: 8),
            // GestureDetector(
            //   onTap: () => controller.selectDate(context),
            //   child: Obx(
            //     () => Container(
            //       padding: const EdgeInsets.symmetric(
            //         vertical: 16,
            //         horizontal: 12,
            //       ),
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             controller.selectedDate.value == null
            //                 ? (controller.dobController.text.isNotEmpty
            //                     ? controller
            //                         .dobController
            //                         .text // Show text from API if no date picked yet
            //                     : 'Select Date of Birth')
            //                 : '${controller.selectedDate.value!.day.toString().padLeft(2, '0')}/${controller.selectedDate.value!.month.toString().padLeft(2, '0')}/${controller.selectedDate.value!.year}',
            //             style: TextStyle(
            //               fontSize: 16,
            //               color:
            //                   controller.selectedDate.value == null &&
            //                           controller.dobController.text.isEmpty
            //                       ? AppColors.grayColor
            //                       : Colors.black,
            //             ),
            //           ),
            //           const Icon(Icons.calendar_today, color: Colors.black54),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),

            // Email (Not updatable via this form as per backend schema)
            const Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              readOnly:
                  true, // Often emails are not editable directly or require verification
              decoration: InputDecoration(
                hintText: 'Enter your Email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey[200], // Indicate read-only
                filled: true,
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number
            const Text(
              'Phone Number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.phoneController, // Enabled
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter your Phone Number...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address
            const Text(
              'Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.addressController, // Enabled
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your Address...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryLightColor),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                    buttonTitle: 'Update Profile',
                    onTap: () async {
                      // Form validation can be added here if needed using a Form widget and GlobalKey
                      await controller.updateProfile();
                      // Snackbar and navigation are handled by the controller now
                    },
                  );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
