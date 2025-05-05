import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jourapothole/core/models/pothole_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:jourapothole/core/config/api_endpoints.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/models/profile_model.dart';
import 'package:jourapothole/core/services/api_services.dart';
import 'package:jourapothole/core/utils/utils.dart';

class ProfileController extends GetxController {
  Rx<File?> pickedImage = Rx<File?>(null);
  List<PotholeModel> allMyPothole = [];

  final Rx<ProfileModel> profile = ProfileModel().obs;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime dateTime = DateTime.now();

  var isLoading = false.obs;
  var isUploading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getProfileData();
    await getMyReports();
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      // Pick an image from the gallery or camera
      final XFile? image = await showModalBottomSheet<XFile?>(
        context: Get.context!,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await picker.pickImage(source: ImageSource.gallery),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await picker.pickImage(source: ImageSource.camera),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

      if (image != null) {
        // Compress the image
        final compressedImage = await compressImage(File(image.path));
        pickedImage.value = compressedImage;

        // Upload the image to server
        await uploadProfileImage(compressedImage);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<File> compressImage(File file) async {
    try {
      // Get file extension
      final fileExt = path.extension(file.path).toLowerCase();

      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}$fileExt',
      );

      // Compress image
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 800,
        minHeight: 800,
        // Use webp format if supported
        format: fileExt == '.webp' ? CompressFormat.webp : CompressFormat.jpeg,
      );

      if (result == null) {
        print('Image compression failed, using original file');
        return file;
      }

      return File(result.path);
    } catch (e) {
      print('Error compressing image: $e');
      // Return original file if compression fails
      return file;
    }
  }

  Future<void> uploadProfileImage(File image) async {
    try {
      isUploading.value = true;
      // After successful upload, refresh profile data
      await getProfileData();
    } catch (e) {
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> getProfileData() async {
    try {
      isLoading.value = true;
      final token = await PrefHelper.getData(Utils.token);

      final response = await ApiServices.getData(
        url: ApiEndpoints.getMe,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // Update the profile model with the fetched data
          profile.value = ProfileModel.fromJson(responseData['data']);

          // Update text controllers with profile data
          fullNameController.text = profile.value.fullName ?? '';
          emailController.text = profile.value.email ?? '';
          // Add other fields as needed
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to fetch profile data',
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      printError(info: 'Error fetching profile data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final token = await PrefHelper.getData(Utils.token);

      final response = await ApiServices.postData(
        url: ApiEndpoints.updateProfile,
        body: {
          'fullName': fullNameController.text,
          'email': emailController.text,
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Refresh the profile data to reflect changes
        await getProfileData();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      printError(info: 'Error updating profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMyReports() async {
    try {
      isLoading.value = true;
      final token = await PrefHelper.getData(Utils.token);

      final response = await ApiServices.getData(
        url: ApiEndpoints.getMyReports,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final data = responseData['data'];
          allMyPothole.clear(); // Clear previous data
          for (var pothole in data) {
            allMyPothole.add(PotholeModel.fromJson(pothole));
          }

          Get.snackbar(
            'Success',
            'Reports fetched successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch reports');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      printError(info: 'Error fetching reports: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to load reports: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    nickNameController.dispose();
    dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
