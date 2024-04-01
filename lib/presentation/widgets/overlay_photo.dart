import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewOverlay extends ModalRoute<void>{
  String? image;
  Uint8List? imageBytes;

  PhotoViewOverlay({this.image, this.imageBytes});
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black.withOpacity(0.7);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return
      Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: image!=null?
                PhotoView(
                    initialScale: PhotoViewComputedScale.contained,
                    backgroundDecoration: BoxDecoration(
                        color: Colors.transparent
                    ),
                    tightMode: true,
                    filterQuality: FilterQuality.high,
                    imageProvider: FileImage(File(image!))
                ):
                PhotoView.customChild(
                  child: Image.memory(imageBytes!),
                  backgroundDecoration: BoxDecoration(
                      color: Colors.transparent
                  ),
                  tightMode: true,
                  initialScale: PhotoViewComputedScale.contained,
                ),
              ),
              Positioned(
                right: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }
}