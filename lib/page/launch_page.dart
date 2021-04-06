import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LaunchPage extends StatefulWidget {
  LaunchPage({Key key}) : super(key: key);
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Timer _timer;
  int second = 3; //剩余秒
  int _count = 3; // 倒计时秒
  @override
  void initState() {
    super.initState();
    // 把状态栏和虚拟按键隐藏掉 以达到全屏效果
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTime();
  }

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 1);
    Timer(_duration, () {
      // 空等1秒之后再计时
      _timer = new Timer.periodic(Duration(milliseconds: 1000), (v) {
        _count--;
        if (_count == 0) {
          _get();
        } else {
          setState(() {
            second = _count;
          });
        }
      });
      return _timer;
    });
  }

  // 判断是否需要登录跳转不同页面
  _get() async {
    _timer.cancel();
    if (await sharedGetData('token') != null) {
      /// 跳转成功路由中删除该页面
      Navigator.pop(context);
      NavigatorUtil.navigateTo(context, PageRouter.home,
          replace: true, clearStack: true);
    } else {
      /// 跳转成功路由中删除该页面
      Navigator.pop(context);
      NavigatorUtil.navigateTo(context, PageRouter.login,
          replace: true, clearStack: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // 把状态栏显示出来，需要一起调用底部虚拟按键（华为系列某些手机有虚拟按键
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: new Image.asset(
              "lib/assets/images/qidongye.PNG", //广告图
              fit: BoxFit.fill,
            ),
          ),
          // 跳过按钮
          Positioned(
            top: 20.w,
            right: 20.w,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  height: 25.w,
                  width: 60.w,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20.w)),
                  child: Center(
                    child: Text(
                      "$second 跳过",
                      style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                    ),
                  ),
                ),
              ),
              onTap: _get,
            ),
          ),
        ],
      ),
    );
  }
}
