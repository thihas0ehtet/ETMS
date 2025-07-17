import 'dart:async';
import 'dart:convert';
import 'package:get/get_connect/http/src/request/request.dart';

Future<Request> requestInterceptor(Request request) async {
  request.headers['X-Requested-With'] = 'XMLHttpRequest';
  request.headers['Accept'] = 'application/json';
  print("Log : Request is ${request.method}");
  print("Log : ${request.url}");

  try {
    final decodedBody = jsonDecode(utf8.decode(request.bodyBytes as List<int>));
    print('Log : BODY: $decodedBody');
  } catch (_) {}

  // print(request.files);
  // print(request.bodyBytes);
  return request;
}
