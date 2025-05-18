import 'package:etms/app/api/request_interceptor.dart';
import 'package:etms/app/api/response_interceptor.dart';
import 'package:etms/app/config/api_constants.dart';
import 'package:get/get.dart';

import 'auth_interceptor.dart';

class BaseProvider extends GetConnect{
  @override
  void onInit() {
    httpClient.baseUrl =ApiConstants.baseUrl;
    httpClient.addAuthenticator(authInterceptor);
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
    httpClient.timeout = const Duration(seconds: 30);
  }
}


