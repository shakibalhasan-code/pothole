import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jourapothole/core/services/location_services.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:jourapothole/features/reports/view/components/reports_details.dart';

class MapServices extends GetxService {
  final locationServices = Get.find<LocationServices>();
  final homeController = Get.find<HomeController>();

  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  final Rxn<CameraPosition> kGooglePlex = Rxn<CameraPosition>();

  late BitmapDescriptor mildIcon;
  late BitmapDescriptor moderateIcon;
  late BitmapDescriptor severeIcon;
  late BitmapDescriptor defaultIcon;

  @override
  void onInit() async {
    super.onInit();
    print("MapServices onInit started");

    // Load icons from Flutter IconData
    mildIcon = await getBitmapFromIcon(Icons.location_on, Colors.purple);
    moderateIcon = await getBitmapFromIcon(Icons.location_on, Colors.orange);
    severeIcon = await getBitmapFromIcon(Icons.location_on, Colors.red);
    defaultIcon = await getBitmapFromIcon(Icons.location_on, Colors.blue);

    try {
      await locationServices.getUserLocationWithAddress();

      kGooglePlex.value = CameraPosition(
        target: LatLng(locationServices.latitude, locationServices.longitude),
        zoom: 14.4746,
      );
      print("kGooglePlex set to user location");
    } catch (e) {
      print("Location error: $e");

      kGooglePlex.value = const CameraPosition(
        target: LatLng(37.422, -122.084),
        zoom: 14.4746,
      );
    }
  }

  // Convert Flutter Icon to BitmapDescriptor for Google Maps
  Future<BitmapDescriptor> getBitmapFromIcon(
    IconData icon,
    Color color, {
    double size = 96,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: icon.fontFamily,
        color: color,
        package: icon.fontPackage,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  // Generate markers dynamically from HomeController.allPothole
  Set<Marker> get markers =>
      homeController.allPothole.map((pothole) {
        BitmapDescriptor icon;

        switch (pothole.severityLevel) {
          case "Mild":
            icon = mildIcon;
            break;
          case "Moderate":
            icon = moderateIcon;
            break;
          case "Severe":
            icon = severeIcon;
            break;
          default:
            icon = defaultIcon;
        }

        return Marker(
          markerId: MarkerId(pothole.location.address),
          icon: icon,
          position: LatLng(
            pothole.location.latitude,
            pothole.location.longitude,
          ),
          infoWindow: InfoWindow(
            title: pothole.issue,
            snippet: pothole.location.address,
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                builder: (context) => ReportProblemBottomSheet(report: pothole),
              );
            },
          ),
        );
      }).toSet();

  Future<void> goToLocation(LatLng target) async {
    final GoogleMapController mapCtrl = await controller.future;
    mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
  }
}
