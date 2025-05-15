// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:jourapothole/core/models/pothole_model.dart';

// class PotholeInfoCard extends StatelessWidget {
//   final PotholeModel pothole; // Use your actual Pothole model
//   final VoidCallback onClose;

//   const PotholeInfoCard({
//     Key? key,
//     required this.pothole,
//     required this.onClose,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize:
//               MainAxisSize
//                   .min, // Important for the card to not take full screen height
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     pothole.issue,
//                     style: Get.textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: onClose,
//                   tooltip: "Close",
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               "Severity: ${pothole.severityLevel}",
//               style: Get.textTheme.titleMedium?.copyWith(
//                 color: _getSeverityColor(pothole.severityLevel),
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               "Address: ${pothole.location.address}",
//               style: Get.textTheme.bodyMedium,
//             ),
//             SizedBox(height: 4),
//             Text(
//               "Coordinates: ${pothole.location.latitude.toStringAsFixed(5)}, ${pothole.location.longitude.toStringAsFixed(5)}",
//               style: Get.textTheme.bodySmall,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: Icon(Icons.directions),
//               label: Text("Get Directions"),
//               onPressed: () {
//                 // Implement navigation or further actions
//                 print("Get directions to ${pothole.location.address}");
//                 // You could launch maps here:
//                 // MapUtils.openMap(pothole.location.latitude, pothole.location.longitude);
//                 onClose(); // Optionally close the card after action
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getSeverityColor(String severity) {
//     switch (severity.toLowerCase()) {
//       case "mild":
//         return Colors.purple;
//       case "moderate":
//         return Colors.orange;
//       case "severe":
//         return Colors.red;
//       default:
//         return Colors.blue;
//     }
//   }
// }
