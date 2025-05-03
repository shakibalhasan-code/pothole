import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jourapothole/core/config/api_endpoints.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/models/profile_model.dart';
import 'package:jourapothole/core/services/api_services.dart';
import 'package:jourapothole/core/utils/utils.dart';

class ProfileController extends GetxController {
  Rx<File?> pickedImage = Rx<File?>(null);

  final Rx<ProfileModel> profile = ProfileModel().obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime dateTime = DateTime.now();

  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getProfileData();
  }

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  Future<void> getProfileData() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getData(
        url: ApiEndpoints.getMe,
        headers: {'Authorization': await PrefHelper.getData(Utils.token)},
      );
      print(response);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final profileData = ProfileModel.fromJson(body['data']);
        printInfo(info: '===>>>>>>>> profile: $profileData');
        profile.value = profileData;
      }
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
