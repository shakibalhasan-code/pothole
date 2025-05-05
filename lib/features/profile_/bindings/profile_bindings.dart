import 'package:get/get.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart';

class ProfileBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProfileController());
  }
}