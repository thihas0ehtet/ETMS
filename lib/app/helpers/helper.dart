import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/config.dart';
import 'error_handling/InternetException.dart';

class Helper{
  Future<void> checkInternetConnection() async{
    bool isConnected = await isInternetConnected();
    if(!isConnected){
      throw InternetException("No internet connection");
    }
  }

  Future<bool> isInternetConnected() async {
    bool connect = false;
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if(!hasInternet){
      return connect;
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connect = true;
      }
    } on SocketException catch (_) {
      connect = false;
    }
    return connect;
  }

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
        openAppSettings();

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
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Camera services are off'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'You must enable in the camera Services settings',
                      style: latoRegular,
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: latoMedium.copyWith(color: ColorResources.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                        'Open Settings', style: latoMedium.copyWith(color: ColorResources.primary600)),
                    onPressed: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                  ),
                ],
              );
            }
        );
        break;
      default:
    }

    if (!storagePermission || !photoPermission || !camerPermission) {
      // showPermissionDialog(context, deniedString);
    }

    return storagePermission && photoPermission && camerPermission;
  }

  static Future<bool> checkCameraPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> permissionRequestResult = await [
      Permission.camera,
    ].request();

    bool locationPermission = false;

    String deniedString = "";
    switch (permissionRequestResult[Permission.camera]) {
      case PermissionStatus.granted:
        locationPermission = true;
        break;
    // case PermissionStatus.denied || :
    //   deniedString = "camera";
    //   break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.denied || PermissionStatus.permanentlyDenied:
        deniedString = "camera";
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Camera services are off'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'You must enable in the camera Services settings',
                      style: latoRegular,
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: latoMedium.copyWith(color: ColorResources.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                        'Open Settings', style: latoMedium.copyWith(color: ColorResources.primary600)),
                    onPressed: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                  ),
                ],
              );
            }
        );

        // openAppSettings();
        break;
      default:
    }

    return locationPermission;
  }

  static Future<bool> checkLocationPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> permissionRequestResult = await [
      Permission.location,
    ].request();

    bool locationPermission = false;

    String deniedString = "";
    switch (permissionRequestResult[Permission.location]) {
      case PermissionStatus.granted:
        locationPermission = true;
        break;
    // case PermissionStatus.denied:
    //   deniedString = "location";
    //   break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.denied || PermissionStatus.permanentlyDenied:
        deniedString = "location";
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Location services are off'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'You must enable in the location Services settings',
                      style: latoRegular,
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: latoMedium.copyWith(color: ColorResources.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                        'Open Settings', style: latoMedium.copyWith(color: ColorResources.primary600)),
                    onPressed: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                  ),
                ],
              );
            }
        );

        // openAppSettings();
        break;
      default:
    }

    return locationPermission;
  }
}