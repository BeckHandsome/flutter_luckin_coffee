import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_luckin_coffee/page/home/check_shop_page.dart';
import 'package:flutter_luckin_coffee/page/home/home_page.dart';
import 'package:flutter_luckin_coffee/page/login_page.dart';
import 'package:flutter_luckin_coffee/page/menu/shopping_detail_page.dart';
import 'package:flutter_luckin_coffee/page/my/discount_coupon_page.dart';
import 'package:flutter_luckin_coffee/page/my/set_page.dart';
import 'package:flutter_luckin_coffee/page/my/upload_files_page.dart';
import 'package:flutter_luckin_coffee/page/my/user_info_page.dart';
import 'package:flutter_luckin_coffee/page/order/settlement_page.dart';
import 'package:flutter_luckin_coffee/page/register/email_register.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/widget/widget_video_player.dart';
import 'package:flutter_luckin_coffee/widget/widget_photo_view.dart';

class RouterHandler {
  // 在这里我定义了一个map集合，key是页面的path,value是按照fluro的要求是一个Handler的实例
  // params是路由的参数
  static final Map<String, Handler> handlerRouter = {
    PageRouter.home: Handler(handlerFunc: (BuildContext context, parameters) {
      return HomePage();
    }),
    PageRouter.login: Handler(handlerFunc: (BuildContext context, parameters) {
      return LoginPage();
    }),
    PageRouter.checkShopPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return CheckShopPage();
    }),
    PageRouter.shoppingDetailPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return ShoppingDetailPage(params: parameters);
    }),
    PageRouter.userInfoPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return UserInfoPage();
    }),
    PageRouter.setPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return SetPage();
    }),
    PageRouter.settlementPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return SettlementPage(params: parameters);
    }),
    PageRouter.emailRegister: Handler(handlerFunc: (BuildContext context, parameters) {
      return EmailRegister();
    }),
    PageRouter.discountCouponPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return DiscountCouponPage();
    }),
    PageRouter.uploadFilesPage: Handler(handlerFunc: (BuildContext context, parameters) {
      return UploadFilesPage();
    }),
    PageRouter.widgetVideoPlayer: Handler(handlerFunc: (BuildContext context, parameters) {
      return WidgetVideoPlayer(params: parameters);
    }),
    PageRouter.widgetPhotoView: Handler(handlerFunc: (BuildContext context, parameters) {
      return WidgetPhotoView(params: parameters);
    }),
  };
}
