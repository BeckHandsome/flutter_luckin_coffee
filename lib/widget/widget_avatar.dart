import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

typedef success<File> = Function(File params);
showSelectAvatar(BuildContext context, {success}) {
  final picker = ImagePicker();
  // 调用裁剪
  Future<File> _imageCropper(String path) async {
    return await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: '裁剪',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: '裁剪',
        minimumAspectRatio: 1.0,
      ),
    );
  }

  Future getCameraImage() async {
    await picker.getImage(source: ImageSource.camera).then(
      (value) {
        _imageCropper(value.path).then((value) => {Navigator.pop(context), if (success != null) success(value)});
      },
    );
  }

  Future getGalleryImage() async {
    await picker.getImage(source: ImageSource.gallery).then(
      (value) async {
        _imageCropper(value.path).then((value) => {Navigator.pop(context), if (success != null) success(value)});
      },
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    builder: (BuildContext context) {
      return Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                getCameraImage();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color.fromRGBO(242, 242, 242, 1), width: 1, style: BorderStyle.solid),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('打开相机'),
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                getGalleryImage();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color.fromRGBO(242, 242, 242, 1), width: 1, style: BorderStyle.solid),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('打开相册'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
