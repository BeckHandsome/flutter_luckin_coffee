import 'package:flutter/cupertino.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/tool/location.dart';

class BaseData extends ChangeNotifier {
  Map _baseData = {
    'shopDetail': {}, //存选中的店铺信息
    'userInfo': {}, // 存用户个人信息
  };
  BaiduLocation _locationInfo; // 获取当前定位的信息
  int _cartNumber = 0; // 购物车数量

  // 写一个增加的方法，然后需要调用notifyListeners();这个方法是通知用到_baseData对象的widget刷新用的。

  // 商店信息
  void addShopDetail(String id) {
    Api.subshopDetail(
      pathParams: {'id': id},
      successCallBack: (r) {
        _baseData['shopDetail'] = r['data']['info'];
        notifyListeners();
      },
    );
  }

  // 用户信息
  void addUserInfo(Map userInfo) {
    _baseData['userInfo'] = userInfo;
    notifyListeners();
  }

  // 定位位置信息
  void addLocationInfo() {
    LocationUnit().getLocation(successCallBack: (BaiduLocation result) {
      print(result.latitude);
      _locationInfo = result;
      notifyListeners();
    });
  }

  // 获取购物车数量
  void addCartNumber() {
    Api.shoppingCartInfo(successCallBack: (r) {
      _cartNumber = r['data']['items'].length;
      notifyListeners();
    }, failCallBack: (err) {
      _cartNumber = 0;
      notifyListeners();
    });
    notifyListeners();
  }

  get baseData => _baseData;
  get locationInfo => _locationInfo;
  int get cartNumber => _cartNumber;
}
