import 'package:get/get.dart';
import 'package:jourapothole/core/services/firebase_services.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/features/auth/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => LocationServices(), fenix: true);
    Get.lazyPut(() => FirebaseServices(), fenix: true);
  }
}
