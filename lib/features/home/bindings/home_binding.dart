import 'package:get/get.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/core/services/map_services.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/profile_/controller/profile_controller.dart';
import 'package:jourapothole/features/reports/controllers/report_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<LocationServices>(() => LocationServices(), fenix: true);
    Get.lazyPut<MapServices>(() => MapServices(), fenix: true);
    Get.lazyPut<ReportController>(() => ReportController(), fenix: true);

    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
