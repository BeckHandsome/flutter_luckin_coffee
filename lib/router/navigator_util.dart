import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/router/application.dart';
import 'package:flutter_luckin_coffee/router/fluro_convert_util.dart';

// 分装fluro 路由跳转
class NavigatorUtil {
  static navigateTo(
    BuildContext context,
    String path, {
    Map<String, dynamic> params, //params为了解决自己页面在path上拼接更多的参数
    bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.fadeIn,
  }) {
    if (params != null) {
      String query = '';
      int index = 0;
      for (var key in params.keys) {
        // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
        String value = '';
        if (params[key] is List || params[key] is Map) {
          value = FluroConvertUtils.object2string(params[key]);
        } else {
          value = FluroConvertUtils.fluroCnParamsEncode(params[key]);
        }

        if (index == 0) {
          query = '?';
        } else {
          query = query + '\&';
        }
        query += '$key=$value';
        index++;
      }
      path = path + query;
    }
    return Application.router.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition,
    );
  }
  // 路由的返回直接用router提供的就行 Navigator.pop(context);
}
