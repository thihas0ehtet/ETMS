import 'package:etms/app/api/request_interceptor.dart';
import 'package:etms/app/api/response_interceptor.dart';
import 'package:etms/app/config/api_constants.dart';
import 'package:get/get.dart';

class BaseProvider extends GetConnect{
  @override
  void onInit() {
    httpClient.baseUrl =ApiConstants.baseUrl;
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);

// Enable logging for all API requests and responses
    httpClient.addResponseModifier((request, response) {
      print('API Response:');
        print('Status Code: ${response.statusCode}');
    print('Body: ${response.bodyString}');
    });
    // httpClient.addResponseModifier((Response response) {
    //   print('API Response:');
    //   print('Status Code: ${response.statusCode}');
    //   print('Body: ${response.bodyString}');
    //   return response;
    // });
  }
}