import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/page/shopping/cart_card_page.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/widget/widget_button.dart';
import 'package:flutter_luckin_coffee/widget/widget_future_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({Key key}) : super(key: key);
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  ValueNotifier<double> _price = ValueNotifier<double>(0);
  ValueNotifier<bool> _isOpenManagement = ValueNotifier<bool>(false);
  List _currentKey = [];
  List _cartData = [];
  @override
  void initState() {
    super.initState();
  }

  Future _getGouwuche() async {
    _currentKey = [];
    return Api.shoppingCartInfo(
      successCallBack: (r) {
        if (r['data']['price'] == 0) {
          _price.value = 0.0;
        } else {
          _price.value = r['data']['price'];
        }
        for (var item in r['data']['items']) {
          if (item['selected']) {
            _currentKey.add(item['key']);
          }
        }
        _cartFun(r['data']['items']);
        return r;
      },
    );
  }

  _cartFun(List data) {
    _cartData = [];
    for (var item in data) {
      if (item['selected']) {
        _cartData.add(item);
      }
    }
  }

  // 清空购物车
  Future _shoppingCartEmpty() async {
    return Api.shoppingCartEmpty(successCallBack: (res) {
      Provider.of<BaseData>(context, listen: false).addCartNumber();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Consumer<BaseData>(
          builder: (BuildContext context, BaseData value, Widget child) => CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                title: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('购物车'),
                    Text(
                      '共${value.cartNumber}件宝贝',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      child: Center(
                        child: Text('管理'),
                      ),
                      onTap: () {
                        _isOpenManagement.value = !_isOpenManagement.value;
                      },
                    ),
                  ),
                ],
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: value.cartNumber == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('lib/assets/images/shopping_cart_null.png'),
                            Text('购物车尽然是空的....'),
                          ],
                        ),
                      )
                    : WidgetFutureBuilder(
                        future: _getGouwuche(),
                        child: (data) {
                          List _shopList = data['items'];
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: CartCardPage(
                              listData: _shopList,
                              onChanged: (val, key) {
                                _currentKey = key;
                                if (val['data']['price'] != 0) {
                                  _price.value = val['data']['price'];
                                } else {
                                  _price.value = 0.0;
                                }
                                _cartFun(val['data']['items']);
                              },
                              numberChanged: (val) {
                                if (val['data']['price'] != 0) {
                                  _price.value = val['data']['price'];
                                } else {
                                  _price.value = 0.0;
                                }
                                _cartFun(val['data']['items']);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ValueListenableBuilder(
          valueListenable: _isOpenManagement,
          builder: (BuildContext context, bool val, Widget child) {
            if (val) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: WidgetButton(
                      text: Text(
                        '清空购物车',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onTap: () {
                        if (Provider.of<BaseData>(context, listen: false).cartNumber != 0) {
                          _shoppingCartEmpty();
                        } else {
                          EasyLoading.showToast('购物车里还没有东西哦!!');
                        }
                      },
                    ),
                  ),
                  WidgetButton(
                    text: Text(
                      '删除',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    onTap: () {
                      if (_currentKey.length != 0) {
                        Api.shoppingCartRemove(
                            pathParams: {'key': _currentKey.join(',')},
                            successCallBack: (res) {
                              _cartFun(res['data']['items']);
                              Provider.of<BaseData>(context, listen: false).addCartNumber();
                              setState(() {});
                            },
                            failCallBack: (err) {
                              Provider.of<BaseData>(context, listen: false).addCartNumber();
                              setState(() {});
                            });
                      } else {
                        EasyLoading.showToast('请选择需要删除的商品');
                      }
                    },
                  ),
                ],
              );
            }
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '合计应付：',
                    ),
                    ValueListenableBuilder(
                      valueListenable: _price,
                      builder: (BuildContext context, double val, Widget child) => Text(
                        '¥$val',
                      ),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    WidgetButton(
                      text: Text(
                        '结算',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onTap: () {
                        if (_currentKey.length != 0) {
                          NavigatorUtil.navigateTo(
                            context,
                            PageRouter.settlementPage,
                            params: {
                              'totalPrice': _price.value.toString(),
                              'goodsJsonStr': _cartData,
                              'isShoppingCart': '1',
                            },
                          );
                        } else {
                          EasyLoading.showToast('购物车里还没有东西哦!!');
                        }
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
