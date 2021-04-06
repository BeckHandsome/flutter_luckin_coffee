import 'package:flutter_luckin_coffee/http/dio_util.dart';

class Api {
  // 邮箱登录
  static Future login({pathParams, Function successCallBack}) async {
    return DioUtil().request("/user/email/login", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 退出登录
  static Future loginOut({pathParams, Function successCallBack}) async {
    return DioUtil().request("/user/loginout", method: 'GET', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 获取邮箱验证码
  static Future mailCode({pathParams, Function successCallBack}) async {
    return DioUtil().request("/verification/mail/get", method: 'GET', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 验证图片验证码是否正确
  static Future verificationPicCheck({pathParams, Function successCallBack}) async {
    return DioUtil().request("/verification/pic/check", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 注册邮箱
  static Future mailRegister({pathParams, Function successCallBack}) async {
    return DioUtil().request("/user/email/register", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 登录用户详情
  static Future userDetail({pathParams, Function successCallBack}) async {
    return DioUtil().request("/user/detail", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 修改用户信息
  static Future userInfoEdit({pathParams, Function successCallBack}) async {
    return DioUtil().request("/user/modify", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 获取门店列表
  static Future subshopList({pathParams, Function successCallBack}) async {
    return DioUtil().request("/shop/subshop/list", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 获取门店详情
  static Future subshopDetail({pathParams, Function successCallBack}) async {
    return DioUtil().request("/shop/subshop/detail/v2", method: 'GET', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 商品类别
  static Future goodsCategory({pathParams, Function successCallBack, failCallBack}) async {
    return DioUtil().request("/shop/goods/category/all", method: 'GET', pathParams: pathParams, successCallBack: successCallBack, failCallBack: failCallBack);
  }

  // 类别详情
  static Future goodsCategoryInfo({pathParams, Function successCallBack}) async {
    return DioUtil().request("/shop/goods/category/info", method: 'GET', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 获取商品列表
  static Future goodsList({pathParams, Function successCallBack}) async {
    return DioUtil().request("/shop/goods/list", method: 'POST', pathParams: pathParams, successCallBack: successCallBack);
  }

  // 获取商品详情
  static Future goodsDetail({pathParams, Function successCallBack}) async {
    return DioUtil().request(
      "/shop/goods/detail",
      method: 'GET',
      pathParams: pathParams,
      successCallBack: successCallBack,
    );
  }

  // 获取商品可选配件
  static Future goodsAddition({pathParams, Function successCallBack}) async {
    return DioUtil().request(
      "/shop/goods/goodsAddition",
      method: 'GET',
      pathParams: pathParams,
      successCallBack: successCallBack,
    );
  }

  // 加入购物车
  static Future addShoppingCart({pathParams, Function successCallBack}) async {
    return DioUtil().request(
      "/shopping-cart/add",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
    );
  }

  // 获取购物车数据
  static Future shoppingCartInfo({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/shopping-cart/info",
      method: 'GET',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 修改购物车选中状态
  static Future shoppingCartSelect({pathParams, Function successCallBack}) async {
    return DioUtil().request(
      "/shopping-cart/select",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
    );
  }

  // 购物车修改购买数量
  static Future shoppingCartNumber({pathParams, Function successCallBack}) async {
    return DioUtil().request(
      "/shopping-cart/modifyNumber",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
    );
  }

  // 清空购物车
  static Future shoppingCartEmpty({pathParams, Function successCallBack}) async {
    return DioUtil().request(
      "/shopping-cart/empty",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
    );
  }

  // 移除购物车中某条记录
  static Future shoppingCartRemove({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/shopping-cart/remove",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 上传文件
  static Future uploadFile({formData, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/dfs/upload/file",
      method: 'POST',
      data: formData,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 上传文件列表
  static Future uploadFileList({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/dfs/upload/list/v2",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 生成订单
  static Future orderCreate({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/order/create",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 支付宝支付
  static Future zhifubao({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/pay/alipay/gate/app",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 获取订单
  static Future orderList({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/order/list",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 获取订单详情
  static Future orderDetail({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/order/detail",
      method: 'GET',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 删除订单
  static Future orderDelete({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/order/delete",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 关闭订单
  static Future orderClose({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/order/close",
      method: 'POST',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 获取优惠券统计数量
  static Future discountsStatistics({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/discounts/statistics",
      method: 'GET',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }

  // 获取优惠券
  static Future discountsList({pathParams, Function successCallBack, Function failCallBack}) async {
    return DioUtil().request(
      "/discounts/my",
      method: 'GET',
      pathParams: pathParams,
      successCallBack: successCallBack,
      failCallBack: failCallBack,
    );
  }
}
