import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/page/menu/redDotPage.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_luckin_coffee/widget/widget_silder_bar.dart';
import 'package:flutter_luckin_coffee/widget/widget_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  List<Map> bannner = [
    {
      'img': 'lib/assets/images/menu/swiper1.jpg',
    },
    {
      'img': 'lib/assets/images/menu/swiper2.png',
    }
  ];
  ValueNotifier<Map> currentValue = ValueNotifier<Map>({});
  List shopDetail = [];
  List _silderTabValue = [];
  String _shopId;
  Offset _endOffset = Offset(340, 850);
  @override
  void initState() {
    super.initState();
  }

  Future _goodsCategory(id) async {
    Api.goodsCategory(
      pathParams: {'shopId': id},
      successCallBack: (res) {
        currentValue.value = res['data'][0];
        _silderTabValue = res['data'];
        setState(() {});
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shopId = Provider.of<BaseData>(context).baseData['shopDetail']['id'].toString();
    if (_shopId != null) {
      _goodsCategory(_shopId);
    }
  }

  // 获取商铺下的商品列表
  Future goodsList(String categoryId, String shopId) async {
    return Api.goodsList(
      pathParams: {
        'categoryId': categoryId,
        'shopId': shopId,
      },
      successCallBack: (res) {
        return res;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '选择咖啡和小食',
            style: TextStyle(color: Style.rgba(56, 56, 56, 1)),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _silderTabValue.length == 0
          ? Center(
              child: Text('我在加载中...请等等我!!!!'),
            )
          : Column(
              children: [
                WidgetSwiper(
                  bannner: bannner,
                  height: 130.w,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: currentValue,
                    builder: (BuildContext context, Map value, Widget child) {
                      return WidgetSilderBar(
                        silderTabValue: _silderTabValue,
                        currentValue: value,
                        onTap: (e) {
                          currentValue.value = e;
                        },
                        future: goodsList(
                          value['id'].toString(),
                          value['shopId'].toString(),
                        ),
                        child: (data) => Container(
                          padding: EdgeInsets.all(15.w),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                height: 100.w,
                                decoration: BoxDecoration(
                                  border: Style.borderBottom(),
                                ),
                                padding: EdgeInsets.fromLTRB(10.w, 10.w, 0, 10.w),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 70.w,
                                      height: 70.w,
                                      child: Image.network(
                                        '${data[index]['pic']}',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10.w),
                                            child: Flex(
                                              direction: Axis.vertical,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${data[index]['name']}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Style.rgba(56, 56, 56, 1),
                                                  ),
                                                ),
                                                Text(
                                                  '${data[index]['subName']}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Style.rgba(166, 166, 166, 1),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '¥${data[index]['minPrice']}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red[400],
                                                      ),
                                                    ),
                                                    data[index]['minPrice'] != data[index]['originalPrice']
                                                        ? Padding(
                                                            padding: EdgeInsets.only(left: 5),
                                                            child: Text(
                                                              '¥${data[index]['originalPrice']}',
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
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            widthFactor: 21.w,
                                            heightFactor: 21.w,
                                            child: Builder(
                                              builder: (ctx) => GestureDetector(
                                                onTap: () {
                                                  // 点击的时候获取当前 widget 的位置，传入 overlayEntry
                                                  var _overlayEntry = OverlayEntry(builder: (_) {
                                                    RenderBox box = ctx.findRenderObject();
                                                    var offset = box.localToGlobal(Offset.zero);
                                                    print(offset);
                                                    return RedDotPage(
                                                      startPosition: offset,
                                                      endPosition: _endOffset,
                                                    );
                                                  });
                                                  // 显示Overlay
                                                  Overlay.of(ctx).insert(_overlayEntry);
                                                  // 等待动画结束
                                                  Future.delayed(Duration(milliseconds: 800), () {
                                                    _overlayEntry.remove();
                                                    _overlayEntry = null;
                                                  });
                                                  NavigatorUtil.navigateTo(
                                                    context,
                                                    PageRouter.shoppingDetailPage,
                                                    params: {
                                                      'id': data[index]['id'].toString(),
                                                    },
                                                  );
                                                },
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(color: Style.rgba(136, 175, 213, 1), borderRadius: BorderRadius.circular(21.r)),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            itemCount: data.length,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
