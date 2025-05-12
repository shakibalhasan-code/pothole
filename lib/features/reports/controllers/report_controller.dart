import 'dart:io';
import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart'; // For Get.snackbar styling and Icons
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jourapothole/core/config/api_endpoints.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/services/api_services.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/core/utils/utils.dart';
import 'package:jourapothole/core/wrappers/body_wrapper.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart'; // For MediaType

class ReportController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxList<File> pickedMedia = <File>[].obs;
  final locationServices = Get.find<LocationServices>();
  final profileController = Get.find<ProfileController>();
  final homeController = Get.find<HomeController>();

  final isVerified = false.obs;

  // --- HTTP Client and API Configuration ---
  final GetConnect _connect = GetConnect();
  RxBool isLoading = false.obs;
  var errorText = ''.obs;

  // --- Method to Pick Multiple Media from Gallery ---
  Future<void> pickMediaFromGallery() async {
    try {
      final List<XFile> mediaFiles = await _picker.pickMultipleMedia();
      if (mediaFiles.isNotEmpty) {
        pickedMedia.addAll(mediaFiles.map((file) => File(file.path)).toList());
        print("Picked ${mediaFiles.length} files from gallery.");
      } else {
        print("No media selected from gallery.");
      }
    } catch (e) {
      print("Error picking media from gallery: $e");
      Get.snackbar(
        'Error',
        'Could not pick media from gallery: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --- Method to Capture Image from Camera ---
  Future<void> captureImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        pickedMedia.add(File(photo.path));
        print("Captured image from camera: ${photo.path}");
      } else {
        print("No image captured from camera.");
      }
    } catch (e) {
      print("Error capturing image from camera: $e");
      Get.snackbar(
        'Error',
        'Could not capture image from camera: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --- Method to Capture Video from Camera ---
  Future<void> captureVideoFromCamera() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        pickedMedia.add(File(video.path));
        print("Captured video from camera: ${video.path}");
      } else {
        print("No video captured from camera.");
      }
    } catch (e) {
      print("Error capturing video from camera: $e");
      Get.snackbar(
        'Error',
        'Could not capture video from camera: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --- Method to Show Choice Dialog/Sheet ---
  void showMediaSourceSelection() {
    Get.bottomSheet(
      Container(
        color: Get.theme.bottomSheetTheme.backgroundColor ?? Colors.white,
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickMediaFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                captureImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Get.back();
                captureVideoFromCamera();
              },
            ),
          ],
        ),
      ),
      // Optional: You can add more styling to the bottom sheet itself
      // backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      // ),
    );
  }

  // --- Method to clear the picked media ---
  void clearMedia() {
    pickedMedia.clear();
    print("Picked media cleared.");
  }

  // --- Method to Create/Submit Report ---
  Future<void> createReport({
    required String? issueType,
    required String? severityLevel,
    required String? description,
    required String? location,
    // double? latitude, // Optional
    // double? longitude, // Optional
  }) async {
    if (issueType == null || issueType.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Issue type is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (severityLevel == null || severityLevel.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Severity level is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (location == null || location.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Location is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isLoading.value = true;

    try {
      Map<String, dynamic> reportDetails = {
        'issue': issueType,
        'severityLevel': severityLevel,
        'description': description ?? '',
        'location': {
          'address': location,
          'coordinates': [locationServices.latt, locationServices.long],
        },
        'user': profileController.profile.value.id,
      };
      String jsonData = jsonEncode(reportDetails);

      final formData = FormData({
        'data': jsonData, // This matches your Postman 'data' field
      });

      List<MultipartFile> imageMultipartFiles = [];
      List<MultipartFile> mediaMultipartFiles =
          []; // For videos or other non-image files

      for (File file in pickedMedia) {
        String fileName = file.path.split('/').last;
        String fileExtension = fileName.split('.').last.toLowerCase();
        MediaType? contentType;
        List<int> fileBytes = await file.readAsBytes();

        if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
          contentType = MediaType(
            'image',
            fileExtension == 'jpg' ? 'jpeg' : fileExtension,
          ); // Common practice for jpg
          imageMultipartFiles.add(
            MultipartFile(
              fileBytes,
              filename: fileName,
              contentType: contentType.toString(),
            ),
          );
        } else if ([
          'mp4',
          'mov',
          'avi',
          'mkv',
          'webm',
        ].contains(fileExtension)) {
          contentType = MediaType('video', fileExtension);
          mediaMultipartFiles.add(
            MultipartFile(
              fileBytes,
              filename: fileName,
              contentType: contentType.toString(),
            ),
          );
        } else {
          print("Unsupported file type: $fileName. It will be skipped.");
          // Optionally, you could add it to a generic 'attachments' field if your backend supports it
          // Or, show a warning to the user.
        }
      }

      // Add image files to FormData under the 'image' key
      // GetConnect handles multiple files with the same key by sending them as an array
      for (var mpFile in imageMultipartFiles) {
        formData.files.add(MapEntry('image', mpFile));
      }

      // Add media (video) files to FormData under the 'media' key
      for (var mpFile in mediaMultipartFiles) {
        formData.files.add(MapEntry('media', mpFile));
      }

      final String token = await PrefHelper.getData(Utils.token);
      final response = await _connect.post(
        ApiEndpoints.pothole,
        formData,
        // Optional: Add headers if needed (e.g., Authorization for a logged-in user)
        headers: {'Authorization': 'Bearer $token'},
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Report submitted successfully: ${response.bodyString}");

        Get.snackbar(
          'Success',
          'Report submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        await profileController.getMyReports();
        await homeController.getPotholeData(); // Refresh the pothole list

        // Safely delay and then pop
        await Future.delayed(const Duration(milliseconds: 800));

        // Clear picked media safely
        try {
          clearMedia();
        } catch (e) {
          print("Error in clearMedia(): $e");
        }
      } else {
        print("Failed to submit report: ${response.statusText}");
        errorText.value = response.statusText ?? 'Unknown error occurred.';
        Get.snackbar(
          'Failed to submit report: $Error',
          errorText.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e, stackTrace) {
      isLoading.value = false;
      print("Exception caught while submitting report: $e");
      print("Stack trace: $stackTrace");
    }
  }

  Future<void> verifyReport({
    required String id,
    required String status,
  }) async {
    isLoading.value = true;
    errorText.value = '';

    try {
      final userId = await PrefHelper.getData(Utils.userId);
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found. Please log in again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final body = {"potholeId": id, "status": status, "userId": userId};

      // Assuming ApiServices.postData handles token internally or doesn't need it directly passed here
      final request = await ApiServices.postData(
        body: body, // Pass the correct body
        url: ApiEndpoints.verifyPothole,
        headers: {
          'Authorization': 'Bearer ${await PrefHelper.getData(Utils.token)}',
        },
      );

      final bodyResponse = jsonDecode(request.body);

      if (request.statusCode == 200 || request.statusCode == 201) {
        Get.back();

        print("Report verified successfully: ${request.body}");
        Get.snackbar(
          'Success',
          'Report verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        // Ensure these controller methods exist and are awaited if they are async
        if (Get.isRegistered<ProfileController>()) {
          // Check if controller is registered
          await Get.find<ProfileController>().getMyReports();
        }
        if (Get.isRegistered<HomeController>()) {
          // Check if controller is registered
          await Get.find<HomeController>().getPotholeData();
        }
      } else {
        Get.back();

        print(
          "Failed to verify report: ${request.statusCode} - ${request.body}",
        );
        // Try to get a meaningful message from the response
        String errorMessage = "Unknown error occurred.";
        if (bodyResponse is Map && bodyResponse.containsKey('message')) {
          errorMessage = bodyResponse['message'].toString();
        } else if (bodyResponse is String) {
          errorMessage = bodyResponse;
        }
        errorText.value = errorMessage;

        Get.snackbar(
          'Failed to Verify Report',
          errorText.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e, stackTrace) {
      // Added stackTrace for better debugging
      print("Error verifying report: $e\n$stackTrace");
      errorText.value = 'An unexpected error occurred: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorText.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }
}
