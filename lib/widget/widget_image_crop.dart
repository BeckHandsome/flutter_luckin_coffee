import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CropImageRoute extends StatefulWidget {
  CropImageRoute({
    Key key,
  }) : super(key: key);

  @override
  _CropImageRouteState createState() => new _CropImageRouteState();
}

class _CropImageRouteState extends State<CropImageRoute> {
  @override
  void initState() {
    super.initState();
  }

  // 获取截图后的数据
  getCropImage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          GestureDetector(
            onTap: () {
              getCropImage();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  '完成',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black26,
        child: Text(''),
      ),
    );
  }
}
