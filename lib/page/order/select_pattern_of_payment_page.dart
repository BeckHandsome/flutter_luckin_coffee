import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/tool/Icon.dart';
import 'package:flutter_luckin_coffee/widget/widget_screen_button.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'dart:convert' as convert;

// 选择支付方式
typedef success<Map> = Function(Map params);
selectPatternOfPayment(BuildContext context, double price, {success, Map params}) {
  print(params);
  List _way = [
    {
      'id': 1,
      'name': '支付宝',
      'img': 'lib/assets/images/zhifubao.png',
    },
    {
      'id': 2,
      'name': '支付宝',
      'img': 'lib/assets/images/weixin.png',
    }
  ];
  void aliPay(String sign) {
    if (sign == null || sign.length == 0) {
      return;
    }
    AlipayResult _payResult;
    bool payState;
    FlutterAlipay.pay(sign).then((payResult) {
      _payResult = payResult;
      print('>>>>>  ${_payResult.toString()}');

      String payResultStatus = _payResult.resultStatus;
      if (payResultStatus == '9000') {
        payState = true;
        EasyLoading.showToast('支付成功');
      } else if (payResultStatus == '8000') {
        payState = false;
        EasyLoading.showToast('支付取消');
      } else if (payResultStatus == '4000') {
        payState = false;
        EasyLoading.showToast('支付失败');
      } else if (payResultStatus == '') {
        payState = false;
        EasyLoading.showToast('等待支付');
      } else if (payResultStatus == '6002') {
        payState = false;
        EasyLoading.showToast('无网络');
      } else if (payResultStatus == '5000') {
        payState = false;
        EasyLoading.showToast('重复支付');
      }
      // jump2PayForCourseDetail();
    }).catchError((e) {
      EasyLoading.showToast('支付失败');
    });
  }

  ValueNotifier<int> _groupValue = ValueNotifier<int>(1);
  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    isDismissible: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    builder: (BuildContext context) {
      return Container(
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color.fromRGBO(242, 242, 242, 1), width: 1, style: BorderStyle.solid),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: IconDatas.iconhebingxingzhuang(color: Colors.grey[400]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text('收银台'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¥'),
                      Text(
                        '$price',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Text('支付金额'),
                ],
              ),
            ),
            Column(
              children: List.generate(
                _way.length,
                (index) => ValueListenableBuilder(
                  valueListenable: _groupValue,
                  builder: (BuildContext context, int value, Widget child) => RadioListTile(
                    title: Flex(
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Image.asset(_way[index]['img']),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(_way[index]['name']),
                        ),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: _way[index]['id'],
                    groupValue: _groupValue.value,
                    onChanged: (e) {
                      _groupValue.value = _way[index]['id'];
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: WidgetScreenButton(
                color: Colors.red,
                text: '确认支付',
                onTap: () async {
                  Api.zhifubao(
                    pathParams: {
                      'money': params['amount'],
                      'nextAction': {'type': 0, 'id': params['orderNumber']}
                    },
                    successCallBack: (res) async {
                      // print(await FlutterAlipay.isInstalled());
                      // if (await FlutterAlipay.isInstalled()) {
                      aliPay(convert.jsonEncode(res['data']));
                      // EasyLoading.showToast('已经安装');
                      // } else {
                      //   EasyLoading.showToast('没有安装');
                      // }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
