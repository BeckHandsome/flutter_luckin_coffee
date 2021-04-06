import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/page/launch_page.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/router/application.dart';
import 'package:flutter_luckin_coffee/router/routes.dart';
import 'package:flutter_luckin_coffee/tool/GlobalUtils.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart' show BMFMapSDK, BMF_COORD_TYPE;

void main() {
  //注入路由
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  WidgetsFlutterBinding.ensureInitialized();
  // 百度地图sdk初始化鉴权
  if (Platform.isIOS) {
    BMFMapSDK.setApiKeyAndCoordType('请在此输入您在开放平台上申请的API_KEY', BMF_COORD_TYPE.COMMON);
  } else if (Platform.isAndroid) {
    // Android 目前不支持接口设置Apikey,
    // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.COMMON);
  }
  runApp(MyApp());
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// 初始化设置屏幕自适应根据设计图大小
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => BaseData())],
      child: ScreenUtilInit(
        designSize: Size(413, 734), // 计图大小
        allowFontScaling: false,
        builder: () => MaterialApp(
          title: '瑞幸咖啡',
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          navigatorKey: GlobalUtils.navigatorKey,
          navigatorObservers: [routeObserver],
          onGenerateRoute: Application.router.generator, //全局注入路由
          home: LaunchPage(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
