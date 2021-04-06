import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/page/order/select_pattern_of_payment_page.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/router/fluro_convert_util.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_luckin_coffee/widget/widget_button.dart';
import 'package:flutter_luckin_coffee/widget/widget_switch_button.dart';
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class SettlementPage extends StatefulWidget {
  SettlementPage({Key key, this.params}) : super(key: key);
  final Map params;
  _SettlementPageState createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  List _params = [];
  bool _currentValue = false;
  String _deliveryTime = '20:00'; //送货时间
  double _totalPrice = 0;
  Map _p = {};
  @override
  void initState() {
    super.initState();
    _p = FluroConvertUtils.fluroMapParamsDecode(widget.params);
    _params = FluroConvertUtils.string2List(_p['goodsJsonStr']);
    _params.forEach((element) {
      element['logisticsType'] = 0;
    });
    _totalPrice = double.parse(_p['totalPrice']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '确认订单',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    SwitchButton(
                      width: 90,
                      height: 36,
                      selectLable: '自提',
                      unSelectLable: '外送',
                      unSelectColor: Colors.white,
                      currentValue: _currentValue,
                      onChanged: (currentValue) {
                        _currentValue = currentValue;
                        setState(() {});
                      },
                    ),
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        _currentValue ? Text('立即配送') : Text('到店自取'),
                        Text(
                          '约$_deliveryTime送达',
                          style: TextStyle(color: Style.rgba(128, 128, 128, 1)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    _currentValue ? Text('送货地址') : Text('自提门店'),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('青年汇店(No.1795)'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('朝阳区朝阳北路青年汇102号楼一层123室'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 订单信息
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Text('订单信息'),
                    Column(
                      children: List.generate(
                        _params.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: [
                              Text('${_params[index]['name']}'),
                              Text('x${_params[index]['number']}'),
                              Text('¥${_params[index]['price']}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Style.borderBottom(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '小计：$_totalPrice',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        width: double.infinity,
        height: 60,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Text('还需支付：¥0'),
              WidgetButton(
                color: Style.rgba(144, 192, 239, 1),
                text: Text(
                  '立即下单',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  EasyLoading.show(status: '生成订单');
                  if (_p['isShoppingCart'] == '1') {
                    List _currentKey = [];
                    for (var item in _params) {
                      _currentKey.add(item['key']);
                    }
                    Api.shoppingCartRemove(
                      pathParams: {'key': _currentKey.join(',')},
                      successCallBack: (res) {
                        Provider.of<BaseData>(context, listen: false).addCartNumber();
                        setState(() {});
                      },
                      failCallBack: (err) {
                        Provider.of<BaseData>(context, listen: false).addCartNumber();
                      },
                    );
                  }
                  Api.orderCreate(
                    pathParams: {
                      'goodsJsonStr': convert.jsonEncode(_params),
                    },
                    successCallBack: (res) {
                      print(res['data']['orderNumber']);
                      EasyLoading.dismiss();
                      selectPatternOfPayment(context, _totalPrice, params: res['data']
                          // {
                          //   'orderNumber': res['data']['orderNumber'],
                          //   'dateAdd': res['data']['dateAdd'],
                          //   'dateClose': res['data']['dateClose'],
                          // },
                          );
                    },
                    failCallBack: () {
                      EasyLoading.dismiss();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
