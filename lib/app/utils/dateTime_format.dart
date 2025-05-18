import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime{
  String? dMY() {
    return
      DateFormat('dd-MMM-yyyy').format(this).toString();
  }

  String? dMYE() {
    return
      DateFormat('dd MMM yyyy, EEEE').format(this).toString();
  }
}