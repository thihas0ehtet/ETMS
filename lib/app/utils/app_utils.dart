import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUtils {
  static Future<bool> checkImagePermission(BuildContext context) async {
    Map<Permission, PermissionStatus> permissionRequestResult = await [
      Permission.storage,
      Permission.camera,
      Permission.photos,
      Permission.unknown
    ].request();

    bool storagePermission = false;
    bool photoPermission = false;
    bool camerPermission = false;

    String deniedString = "";
    switch (permissionRequestResult[Permission.storage]) {
      case PermissionStatus.granted:
        storagePermission = true;
        break;
      case PermissionStatus.denied:
        deniedString = "storage";
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.permanentlyDenied:
      // openAppSettings();
        break;
      default:
    }

    switch (permissionRequestResult[Permission.photos]) {
      case PermissionStatus.granted:
        photoPermission = true;
        break;
      case PermissionStatus.denied:
      // openAppSettings();

        deniedString = "Photos";

        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.permanentlyDenied:
      // openAppSettings();

        break;
      default:
    }

    switch (permissionRequestResult[Permission.camera]) {
      case PermissionStatus.granted:
        camerPermission = true;
        break;
      case PermissionStatus.denied:
        deniedString = "Camera";

        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      default:
    }

    if (!storagePermission || !photoPermission || !camerPermission) {
      // showPermissionDialog(context, deniedString);
    }

    return storagePermission && photoPermission && camerPermission;
  }

  static Future<bool> checkLocationPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> permissionRequestResult = await [
      Permission.location,
    ].request();

    bool locationPermission = false;

    String deniedString = "";
    print("LFKSDJ LOOK ${Permission.location} amm ${PermissionStatus}");
    switch (permissionRequestResult[Permission.location]) {
      case PermissionStatus.granted:
        locationPermission = true;
        break;
      case PermissionStatus.denied:
        deniedString = "location";
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.permanentlyDenied:
        deniedString = "location";
        openAppSettings();
        break;
      default:
    }

    return locationPermission;
  }
}