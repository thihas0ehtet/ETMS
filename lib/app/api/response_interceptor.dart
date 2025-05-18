import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

Future<dynamic> responseInterceptor(
    Request request, Response response) async {
  // EasyLoading.dismiss();

  // if (response.statusCode != 200) {
  //   handleErrorStatus(response);
  //   return response;
  // }
  return response;
}

void handleErrorStatus(Response response) {
  switch (response.statusCode) {
    case 400:
      throw 400;
    case 500:
    default:
  }

  return;
}