// import 'dart:convert';
// import 'package:active_ecommerce_flutter/custom/device_info.dart';
// import 'package:active_ecommerce_flutter/domain/core/network/middleware.dart';
// import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:rice_milling_mobile/domain/network/middleware.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:one_context/one_context.dart';

// class MaintenanceMiddleware extends Middleware {
//   @override
//   bool next(http.Response response) {
//     try {
//       var jsonData = jsonDecode(response.body);
//       if (jsonData.runtimeType != List &&
//           jsonData['result'] != null &&
//           !jsonData['result']) {
//         if (jsonData.containsKey("status") &&
//             jsonData['status'] == "maintenance") {
//           OneContext().addOverlay(
//               overlayId: "maintenance",
//               builder: (context) => Scaffold(
//                     body: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 24),
//                       height: DeviceInfo(context).height!,
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/maintenance.png",
//                             ),
//                             const SizedBox(
//                               height: 14,
//                             ),
//                             Text(
//                               jsonData['message'],
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: MyTheme.font_grey),
//                             )
//                           ]),
//                     ),
//                   ));
//           return false;
//         }
//       }
//     } catch (e) {
//       debugPrint("MaintenanceMiddleware");
//     }
//     return true;
//   }
// }
