import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/router/fluro_convert_util.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetPhotoView extends StatefulWidget {
  WidgetPhotoView({Key key, this.params}) : super(key: key);
  final Map params;
  @override
  _WidgetPhotoViewState createState() => _WidgetPhotoViewState();
}

class _WidgetPhotoViewState extends State<WidgetPhotoView> {
  List _dataList = [];
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    Map _p = FluroConvertUtils.fluroMapParamsDecode(widget.params);
    _dataList = FluroConvertUtils.string2List(_p['dataList']);
    if (_p['current'] != null) {
      for (var i = 0; i < _dataList.length; i++) {
        if (_p['current'] == _dataList[i]) {
          currentIndex = i;
        }
      }
    } else {
      currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: BouncingScrollPhysics(),
              builder: (BuildContext cxt, int i) {
                return PhotoViewGalleryPageOptions.customChild(
                  child: PhotoView(
                    imageProvider: NetworkImage("${_dataList[i]}"),
                  ),
                  // initialScale: PhotoViewComputedScale.contained * 0.8,
                  // heroAttributes: PhotoViewHeroAttributes(tag: i),
                );
              },
              pageController: PageController(initialPage: currentIndex),
              itemCount: _dataList.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 1.sw / 2 - 10,
              child: Text(
                '${currentIndex + 1}/${_dataList.length}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Positioned(
              //右上角关闭按钮
              right: 10,
              top: MediaQuery.of(context).padding.top,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
