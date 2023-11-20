import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

Future<Request> requestInterceptor(Request request) async {
  print("HEYY THIS IS REQUEST");
  request.headers['X-Requested-With'] = 'XMLHttpRequest';
  request.headers['Accept'] = 'application/json';
  // print("Request is $request");
  // print(request.url);
  // print(request.files);
  // print(request.bodyBytes);
  return request;
}
