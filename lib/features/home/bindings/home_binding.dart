import 'package:get/get.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LocationServices>(() => LocationServices());
  }
}
