import 'package:flutter/cupertino.dart';

class GlobalUtils {
  /// *********************************** GlobalUtils 静态属性 ***********************************
  /// 全局变量 - 导航的Globalkey
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// 环境模式
  static final bool isDev = true;

  /// 编译版本号
  static final int buildVersion = 255;

  /// 全局Context
  static final BuildContext globalContext =
      navigatorKey.currentState.overlay.context;

  static final OverlayState globalOverlay = navigatorKey.currentState.overlay;
}
