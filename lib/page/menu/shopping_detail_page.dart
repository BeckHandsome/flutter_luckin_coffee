import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/widget/widget_add_subtract_number.dart';
import 'package:flutter_luckin_coffee/widget/widget_button.dart';
import 'package:flutter_luckin_coffee/widget/widget_future_builder.dart';
import 'package:flutter_luckin_coffee/widget/widget_radio_button.dart';
import 'package:flutter_luckin_coffee/widget/widget_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_luckin_coffee/router/fluro_convert_util.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:provider/provider.dart';

class CurrentListModel with ChangeNotifier {
  String _currentName = '';

  void getCurrentName(List data) {
    _currentName = '';
    for (var item in data) {
      if (item['check'] != null) {
        _currentName += item['check']['name'] + '+￥' + item['check']['price'].toString();
      }
    }
    notifyListeners();
  }

  get currentList => _currentName;
}

class ShoppingDetailPage extends StatefulWidget {
  ShoppingDetailPage({Key key, this.params}) : super(key: key);
  final Map<String, dynamic> params;
  _ShoppingDetailPageState createState() => _ShoppingDetailPageState();
}

class _ShoppingDetailPageState extends State<ShoppingDetailPage> {
  List bannner = [];
  Map _params = {};
  Map shoppingDetail = {};
  List properties = [];
  int _nums = 0;
  ValueNotifier<List> currentValue = ValueNotifier<List>([]);

  void initState() {
    super.initState();
    _params = FluroConvertUtils.fluroMapParamsDecode(widget.params);
  }

  // 获取商品详情
  Future goodsDetail(String id) async {
    return Api.goodsDetail(
      pathParams: {
        'id': id,
      },
      successCallBack: (res) {
        return res;
      },
    );
  }

  // 获取商品可选配件
  Future goodsAddition(String goodsId) async {
    return Api.goodsAddition(pathParams: {
      'goodsId': goodsId,
    }, successCallBack: (res) => res);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentListModel>(
      create: (context) => CurrentListModel(),
      child: Scaffold(
        backgroundColor: Style.rgba(239, 239, 239, 1),
        body: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 208.w,
                flexibleSpace: FlexibleSpaceBar(
                  background: // 轮播图
                      Padding(
                    padding: EdgeInsets.all(0),
                    child: WidgetFutureBuilder(
                      future: goodsDetail(_params['id']),
                      child: (res) {
                        if (res['pics2'].length != 0) {
                          bannner = res['pics2'];
                        }
                        return WidgetSwiper(
                          bannner: bannner,
                          isWebImage: true,
                          height: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => WidgetFutureBuilder(
                    future: goodsDetail(_params['id']),
                    child: (res) {
                      shoppingDetail = res;
                      print(shoppingDetail);
                      return Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 10.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${shoppingDetail['basicInfo']['name'] ?? ''}',
                                          style: TextStyle(
                                            color: Style.rgba(56, 56, 56, 1),
                                          ),
                                        ),
                                        Text(
                                          '${shoppingDetail['basicInfo']['subName' ?? '']}',
                                          style: TextStyle(color: Style.rgba(128, 128, 128, 1), fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: WidgetFutureBuilder(
                                      future: goodsAddition(shoppingDetail['basicInfo']['id'].toString()),
                                      child: (r) {
                                        return Flex(
                                          direction: Axis.vertical,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                            r.length,
                                            (index) {
                                              return Padding(
                                                key: UniqueKey(),
                                                padding: EdgeInsets.all(5),
                                                child: Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    SizedBox(
                                                      width: 50.w,
                                                      child: Text('${r[index]['name']}'),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: WidgetRadioButton(
                                                        listData: r[index]['items'],
                                                        lable: 'name',
                                                        currentValue: r[index]['items'][0],
                                                        onTap: (val) {
                                                          for (var item in r) {
                                                            if (val['pid'] == item['id']) {
                                                              item['check'] = val;
                                                            }
                                                          }
                                                          properties = r;
                                                          Provider.of<CurrentListModel>(context, listen: false).getCurrentName(r);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 10.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text('商品详情'),
                                        ),
                                        Html(
                                          data: shoppingDetail['content'],
                                          onLinkTap: (url) {
                                            print('$url');
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 100.w,
          color: Colors.white,
          padding: EdgeInsets.all(10.w),
          child: WidgetFutureBuilder(
            future: goodsDetail(_params['id']),
            child: (data) {
              return Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '¥${data['basicInfo']['minPrice']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red[400],
                                  ),
                                ),
                                data['basicInfo']['minPrice'] != data['basicInfo']['originalPrice']
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          '¥${data['basicInfo']['originalPrice']}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Style.rgba(166, 166, 166, 1),
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      )
                                    : Text(''),
                              ],
                            ),
                            Consumer<CurrentListModel>(
                              builder: (BuildContext context, CurrentListModel current, Widget child) {
                                return Text(
                                  '${data['basicInfo']['name']} ${Provider.of<CurrentListModel>(context)._currentName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Style.rgba(166, 166, 166, 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        WidgetAddSubtractNumber(onTap: (val) {
                          _nums = val;
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        WidgetButton(
                          color: Colors.red[400],
                          text: Text(
                            '立即购买',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            NavigatorUtil.navigateTo(
                              context,
                              PageRouter.settlementPage,
                              params: {
                                'totalPrice': (data['basicInfo']['originalPrice'] * _nums).toString(),
                                'goodsJsonStr': [
                                  {
                                    'goodsId': data['basicInfo']['id'],
                                    'number': _nums,
                                    'price': data['basicInfo']['originalPrice'] * _nums,
                                    'name': data['basicInfo']['name'],
                                  }
                                ],
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: WidgetButton(
                            onTap: () {
                              List _addition = [];
                              properties.forEach((element) {
                                _addition.add(element['check']);
                              });
                              Api.addShoppingCart(
                                pathParams: {
                                  'goodsId': data['basicInfo']['id'],
                                  'number': _nums,
                                  'addition': _addition,
                                },
                                successCallBack: (res) {
                                  EasyLoading.showSuccess('添加购物车，在购物车等亲~');
                                  Provider.of<BaseData>(context, listen: false).addCartNumber();
                                },
                              );
                            },
                            text: Text(
                              '加入购物车',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
