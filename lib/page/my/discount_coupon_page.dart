import 'package:date_format/date_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/widget/widget_button.dart';

class DiscountCouponPage extends StatefulWidget {
  DiscountCouponPage({Key key}) : super(key: key);
  _DiscountCouponPageState createState() => _DiscountCouponPageState();
}

class _DiscountCouponPageState extends State<DiscountCouponPage> with TickerProviderStateMixin {
  TabController _tabController;
  List _tabs = [];
  @override
  void initState() {
    super.initState();
    // 0 正常 1 失效 2 过期已结束 3 已使用
    _tabs = [
      {"name": "可用", "id": 0},
      {"name": "失效", "id": 1},
      {"name": "过期/已结束", "id": 2},
      {"name": "已使用", "id": 3},
    ];
    _tabController = TabController(initialIndex: 0, length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('优惠券'),
      ),
      body: Container(
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
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
                  (int index) => DiscountCouponList(
                    type: _tabs[index]['id'],
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

class DiscountCouponList extends StatefulWidget {
  DiscountCouponList({Key key, @required this.type}) : super(key: key);
  final int type;
  @override
  _DiscountCouponListState createState() => _DiscountCouponListState();
}

class _DiscountCouponListState extends State<DiscountCouponList> {
  @override
  void initState() {
    super.initState();
    _discountCouponList(type: widget.type);
  }

  List _listData = [];
  _discountCouponList({int type}) {
    Api.discountsList(
      pathParams: {
        'status': type.toString() ?? null,
      },
      successCallBack: (res) => {
        _listData = res['data'] ?? [],
        print(_listData),
        setState(() {}),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _listData.length == 0
        ? Center(
            child: Text('无优惠券抓紧领取哦！！'),
          )
        : ListView(
            children: _listData
                .map(
                  (item) => GestureDetector(
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: DottedBorder(
                                        customPath: (size) {
                                          Path customPath = Path()
                                            ..moveTo(size.width, size.height)
                                            ..lineTo(0, size.height)
                                            ..lineTo(0, size.height)
                                            ..lineTo(0, size.height);
                                          return customPath;
                                        },
                                        padding: EdgeInsets.only(bottom: 8),
                                        color: Colors.grey[400],
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  child: Text('${item['name']}'),
                                                ),
                                                Text(
                                                  '${formatDate(DateTime.parse(item['dateStart']), [yyyy, '-', mm, '-', dd])}至${formatDate(DateTime.parse(item['dateEnd']), [yyyy, '-', mm, '-', dd])}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${item['money']}',
                                                      style: TextStyle(color: Colors.red, fontSize: 25),
                                                    ),
                                                    Text(
                                                      '元',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '满${item['moneyHreshold']}元可用',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Panel(),
                                            // Text('立即使用'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 68,
                                  left: -10,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 68,
                                  right: -10,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
  }
}

class Panel extends StatefulWidget {
  Panel({Key key}) : super(key: key);
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  bool _expaned = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _expaned = !_expaned;
                  setState(() {});
                },
                child: Text('查看使用规则'),
              ),
              _expaned
                  ? Column(
                      children: [
                        Text('1111'),
                        Text('1111'),
                      ],
                    )
                  : Text(''),
            ],
          ),
          _expaned
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _expaned = !_expaned;
                    setState(() {});
                  },
                  child: Icon(Icons.keyboard_arrow_up),
                )
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _expaned = !_expaned;
                    setState(() {});
                  },
                  child: Icon(Icons.keyboard_arrow_down),
                ),
        ],
      ),
    );
  }
}
