// import 'package:permission_handler/permission_handler.dart';

// enum AppPermissions {
//   granted,
//   denied,
//   restricted,
//   permanentlyDenied,
// }

// class PermissionsService {
//   static Future<bool> requestPermission(Permission permission) async {
//     var result = await permission.request();
//     if (result == PermissionStatus.granted) {
//       return true;
//     }
//     return false;
//   }

//   static Future<bool> requestLocationPermission() async {
//     if (await Permission.location.isGranted) {
//       return true;
//     } else {
//       var result = await Permission.location.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

// // try {
// //             await PermissionsService.requestLocationPermission();
// //           } catch (e) {
// //             CustomDialogs.customConfirmAlertWidget(
// //               context,
// //               "Permission Denied",
// //               "Allow access to locations.",
// //               openAppSettings,
// //               actionText2: "Cancel",
// //               actionText1: "Settings",
// //             );
// //           }
// //         }
