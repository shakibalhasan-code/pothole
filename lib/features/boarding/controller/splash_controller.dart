import 'package:get/get.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/utils/routes/app_pages.dart';
import 'package:jourapothole/core/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  var isNewUser = false.obs;
  var isConnected = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await checkNetwork();
    await initUser();
    // await checkPermissions();
    Future.delayed(const Duration(seconds: 3), () {
      if (isConnected.value) {
        // Navigate only if connected
        Get.offNamed(isNewUser.value ? Routes.onBoarding : Routes.mainParent);
      } else {
        Get.snackbar(
          'No Internet',
          'Please connect to the internet to proceed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  Future<void> checkNetwork() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        isConnected.value = false;
        Get.snackbar(
          'No Internet',
          'Please check your internet connection',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        isConnected.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check network status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses =
          await [
            Permission.camera,
            Permission.photos, // For iOS gallery access
            Permission.storage, // For Android gallery access
          ].request();

      if (statuses[Permission.camera]!.isGranted &&
          (statuses[Permission.storage]!.isGranted ||
              statuses[Permission.photos]!.isGranted)) {
        print("All permissions granted");
      } else {
        print("Permissions denied");
      }
    } catch (e) {
      printError(info: "Error requesting permissions: $e");
    }
  }

  Future<void> initUser() async {
    final token = await PrefHelper.getData(Utils.token);
    isNewUser.value = token.isEmpty;
  }
}
