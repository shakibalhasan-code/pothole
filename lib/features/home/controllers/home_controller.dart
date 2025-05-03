import 'dart:convert';
import 'package:get/get.dart';
import 'package:jourapothole/core/config/api_endpoints.dart';
import 'package:jourapothole/core/models/pothole_model.dart';
import 'package:jourapothole/core/services/api_services.dart';

class HomeController extends GetxController {
  RxList<PotholeModel> allPothole = RxList();
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getPotholeData();
  }

  Future<void> getPotholeData() async {
    try {
      isLoading.value = true;
      allPothole.clear();

      final response = await ApiServices.getData(url: ApiEndpoints.pothole);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        printInfo(info: 'Data received: ${data.length} items');

        for (var patholeJson in data) {
          // Use a better variable name
          try {
            // Create the model and ADD it to the RxList
            final pothole = PotholeModel.fromJson(patholeJson);
            allPothole.add(pothole);
          } catch (e, stack) {
            // Log errors for individual item parsing
            printError(
              info:
                  'Error parsing pothole item: $patholeJson\nError: $e\nStack: $stack',
            );
          }
        }
        printInfo(info: 'allPothole size after adding: ${allPothole.length}');
      } else {
        // Handle non-200 status codes
        printError(
          info: 'API call failed with status code: ${response.statusCode}',
        );
        // You might want to show an error message to the user
      }
    } catch (e, stack) {
      printError(info: 'Error fetching pothole data: $e\nStack: $stack');
      // You might want to show an error message to the user
    } finally {
      isLoading.value = false; // Set loading to false when done
    }
  }
}
