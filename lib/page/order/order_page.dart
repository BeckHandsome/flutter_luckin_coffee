import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/page/order/select_pattern_of_payment_page.dart';
import 'package:flutter_luckin_coffee/widget/widget_button.dart';
import 'package:flutter_luckin_coffee/widget/widget_future_builder.dart';
import 'package:flutter_luckin_coffee/widget/widget_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  TabController _tabController;
  List _tabs = [];
  @override
  void initState() {
    super.initState();
    // -1 已关闭 0 待支付 1 已支付待发货 2 已发货待确认 3 确认收货待评价 4 已评价
    _tabs = [
      {
        "name": "全部",
      },
      {"name": "待付款", "id": 0},
      {"name": "待发货", "id": 1},
      {"name": "待收货", "id": 1},
      {"name": "待评价", "id": 3},
    ];
    _tabController = TabController(initialIndex: 0, length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '我的订单',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.all(0),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: _tabs
                    .map(
                      (i) => Tab(
                        text: "${i['name']}",
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  _tabs.length,
                  (index) => OrderList(
                    status: _tabs[index]['id'] ?? null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  OrderList({Key key, @required this.status}) : super(key: key);
  final int status;
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  ScrollController _controller = ScrollController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  List _listData = [];
  Map _goodsMap = {};
  int _page = 1;
  int _pageSize = 10;
  void _onRefresh() async {
    _page = 1;
    await Api.orderList(
      pathParams: {
        'status': widget.status ?? null,
        'page': _page.toString(),
        'pageSize': _pageSize.toString(),
      },
      successCallBack: (res) {
        _listData = res['data']['orderList'] ?? [];
        _goodsMap = res['data']['goodsMap'] ?? {};
        setState(() {});
      },
    );
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _orderListFun() async {
    await Api.orderList(
      pathParams: {
        'status': widget.status ?? null,
        'page': (++_page).toString(),
        'pageSize': _pageSize.toString(),
      },
      successCallBack: (res) {
        print(res['data']['orderList']);
        List l = res['data']['orderList'] != null ? res['data']['orderList'] : [];
        Map m = res['data']['goodsMap'] != null ? res['data']['goodsMap'] : {};
        _listData = [..._listData, ...l];
        _goodsMap = {..._goodsMap, ...m};
        if (mounted) setState(() {});
      },
    );
    // if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  String _statusFilter(int status) {
    // -1 已关闭 0 待支付 1 已支付待发货 2 已发货待确认 3 确认收货待评价 4 已评价
    String _name = '';
    switch (status) {
      case -1:
        _name = '交易关闭';
        break;
      case 0:
        _name = '待支付';
        break;
      default:
        _name = '交易成功';
    }
    return _name;
  }

  // 获取订单详情
  Future _orderDetail(String id, String orderNumber) async {
    return Api.orderDetail(
      pathParams: {
        'id': id,
        'orderNumber': orderNumber,
      },
      successCallBack: (res) {
        return res;
      },
    );
  }

  Widget _goods(String id) {
    List _items = _goodsMap[id] ?? [];
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: List.generate(
          _items.length,
          (index) => Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.network(
                            _items[index]['pic'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('${_items[index]['goodsName']}'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('x${_items[index]['number']}'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('${_items[index]['amountSingle']}元'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opration(BuildContext context, Map params, int index) {
    // -1 已关闭 0 待支付 1 已支付待发货 2 已发货待确认 3 确认收货待评价 4 已评价
    Widget _widget;
    switch (params['status']) {
      case -1:
        _widget = Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WidgetButton(
              text: Text(
                '删除订单',
              ),
              onTap: () {
                Api.orderDelete(
                  pathParams: {
                    'orderId': params['id'],
                  },
                  successCallBack: (res) {
                    setState(() {
                      _listData.removeAt(index);
                    });
                    EasyLoading.showSuccess('删除成功');
                  },
                );
              },
            ),
          ],
        );
        break;
      case 0:
        _widget = Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WidgetButton(
              text: Text(
                '取消订单',
              ),
              onTap: () {
                Api.orderClose(
                  pathParams: {
                    'orderId': params['id'],
                  },
                  successCallBack: (res) {
                    _onRefresh();
                    EasyLoading.showSuccess('取消成功');
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: WidgetButton(
                text: Text(
                  '去付款',
                ),
                onTap: () {
                  selectPatternOfPayment(context, params['amount'], params: params);
                },
              ),
            ),
          ],
        );
        break;
      default:
        _widget = Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [],
        );
    }
    return _widget;
  }

  @override
  Widget build(BuildContext context) {
    return _listData.length == 0
        ? Center(
            child: Text('暂无数据'),
          )
        : WidgetRefresh(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _orderListFun,
            child: ListView(
              controller: _controller,
              children: List.generate(
                _listData.length,
                (index) => SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: Axis.vertical,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_listData[index]['shopName']}>'),
                              Text(
                                '${_statusFilter(_listData[index]['status'])}',
                                style: TextStyle(color: Colors.red[200]),
                              )
                            ],
                          ),
                          _goods(_listData[index]['id'].toString()),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Flex(
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: [Text('合计: ${_listData[index]['amount']}')],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: _opration(context, _listData[index], index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
