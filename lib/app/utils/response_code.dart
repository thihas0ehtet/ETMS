import 'package:get/get.dart';

extension ResponseCode on int {
  bool get codeSuccess {
    return (this ~/ 100) == 2;
  }
}