import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jourapothole/core/helpers/pref_helper.dart';
import 'package:jourapothole/core/utils/routes/app_pages.dart';
import 'package:jourapothole/core/utils/utils.dart';

class SplashController extends GetxController {
  var isNewUser = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await initUser();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(isNewUser.value ? Routes.onBoarding : Routes.mainParent);
    });
  }

  Future<void> initUser() async {
    final token = await PrefHelper.getData(Utils.token);
    token.isEmpty ? isNewUser.value = true : false;
  }
}
