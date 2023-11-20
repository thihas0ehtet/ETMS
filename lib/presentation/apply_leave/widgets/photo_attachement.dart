import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/config/config.dart';
import '../../../app/utils/app_utils.dart';
import '../../widgets/overlay_photo.dart';

class PhotoAttachmentView extends StatefulWidget {
  const PhotoAttachmentView({super.key});

  @override
  State<PhotoAttachmentView> createState() => _PhotoAttachmentViewState();
}

class _PhotoAttachmentViewState extends State<PhotoAttachmentView> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if(image!=null){
      setState(() {
        imageFile=File(image.path);
      });
    }
  }

  Future<void> _onImageButtonPressed({
    required BuildContext context,
  }) async {
    _picker.pickImage(source: ImageSource.gallery, imageQuality: 80).then((value) {
      setState(() {
        imageFile=File(value!.path);
      });
    }).catchError((e) {
      if (e.toString().contains('photo_access_denied')) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "You need to accept permission to select image",
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.black, backgroundColor: Colors.grey.shade300),
                  ),
                  TextButton(
                    child: Text("Accept"),
                    onPressed: () {
                      AppUtils.checkImagePermission(context).then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                          // AppUtils.showSnackChek("You accept permission");
                        } else {
                          Navigator.of(context).pop();
                          // AppUtils.showSnackChek("You do not accept permission",
                          //     color: Colors.red);
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white, backgroundColor: Colors.indigo),
                  ),
                ],
              );
            });
      }
    });
  }

  showPhotoOptions(){
    showModalBottomSheet(
        backgroundColor: ColorResources.white,
        context: context,
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),)
        ),
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              Text(
                "Choose an action",
                style: latoSemibold.copyWith(fontSize: 16),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      pickImageFromCamera();
                    },
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt_outlined,size: 30),
                        Text('Camera')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await _onImageButtonPressed(context: context);
                    },
                    child: Column(
                      children: [
                        Icon(Icons.image,size: 30,),
                        Text('Gallery')
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Photo Attachment").paddingOnly(top: 20, bottom: 10),
        if(imageFile!=null)
        Container(
            decoration: BoxDecoration(
                color: ColorResources.white,
                border: Border.all(color: ColorResources.border)
            ),
            child: Stack(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(PhotoViewOverlay(image: imageFile!.path.toString()
                      ));
                    },
                    child: Image.file(imageFile!, fit: BoxFit.fitWidth, width: context.width, height: 150,)),
                Positioned(
                    bottom: 5,
                    right: 10,
                    child: InkWell(
                      onTap: (){
                        showPhotoOptions();
                      },
                      child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: ColorResources.white,
                              shape: BoxShape.circle
                          ),
                          child: DottedBorder(
                              padding: EdgeInsets.all(5),
                              dashPattern: [3],
                              color: ColorResources.border,
                              borderType: BorderType.Circle,
                              child: Icon(Icons.camera_alt_outlined))),
                    ))
              ],
            )
        ).paddingOnly(bottom: 25),
        if(imageFile==null)
          DottedBorder(
              dashPattern: [5],
              color: ColorResources.border,
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                color: ColorResources.white,
                width: context.width,
                child: GestureDetector(
                  onTap: (){
                    showPhotoOptions();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt_outlined).paddingOnly(bottom: 5),
                      Text('Please take a photo')
                    ],
                  ),
                ),
              )
          ),

      ],
    );
  }
}
