import 'package:get/get.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/core/services/map_services.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<LocationServices>(() => LocationServices(), fenix: true);
    Get.lazyPut<MapServices>(() => MapServices(), fenix: true);
  }
}
