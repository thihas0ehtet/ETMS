import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'error_handling/InternetException.dart';

class Helper{
  // Future<bool> checkInternetConnectivity() async {
  //   // bool hasInternet = await InternetConnectionChecker().hasConnection;
  //   bool hasInternet = await isConnected();
  //   return hasInternet;
  // }

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
}