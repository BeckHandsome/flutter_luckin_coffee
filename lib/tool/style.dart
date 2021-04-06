import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Style {
  static Border borderBottom() => Border(
        bottom: BorderSide(
            color: Color.fromRGBO(242, 242, 242, 1),
            width: 1,
            style: BorderStyle.solid),
      );
  static Border borderAll() => Border.all(
        color: Color.fromRGBO(99, 71, 58, 0.2),
        width: 1,
        style: BorderStyle.solid,
      );
  static Color rgba(int r, int g, int b, double opacity) =>
      Color.fromRGBO(r, g, b, opacity);

  /// app状态栏颜色
  // static void statusBarColor({Color color = Colors.white}) {
  //   SystemChrome.setSystemUIOverlayStyle(
  //       SystemUiOverlayStyle(statusBarColor: color));
  // }
}
