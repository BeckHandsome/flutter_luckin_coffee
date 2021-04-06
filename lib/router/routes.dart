import 'package:fluro/fluro.dart';
import 'package:flutter_luckin_coffee/router/router_handler.dart';

class Routes {
  static final appRouter = FluroRouter();
  static void configureRoutes(FluroRouter appRouter) {
    // //notFoundHandler是匹配不到路由时执行出发的
    // appRouter.notFoundHandler = new Handler(
    //   handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
    //       NotRoutePage(),
    // );
    RouterHandler.handlerRouter.forEach((path, handler) {
      appRouter.define(path,
          handler: handler, transitionType: TransitionType.inFromRight);
    });
  }
}
