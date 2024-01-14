import 'package:get/get.dart';

class UploadPhotoData {
  MultipartFile? file;
  String? id;

  UploadPhotoData(
      {
        this.file,
        this.id
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file'] = file;
    data['id'] = id;
    return data;
  }
}
