import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/Icon.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';
import 'package:flutter_luckin_coffee/widget/widget_border_list_title.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  ScrollController _controller = ScrollController();
  bool _flag = true;
  Map _userInfo = {};
  int _count = 0;
  @override
  void initState() {
    super.initState();
    token();
    getUserInfo();
    _discountsStatistics();
    _controller.addListener(() {
      if (_controller.offset >= 120) {
        setState(() {
          _flag = false;
        });
      } else {
        setState(() {
          _flag = true;
        });
      }
    });
  }

  // 获取个人信息
  getUserInfo() {
    Api.userDetail(successCallBack: (res) {
      _userInfo = res['data']['base'];
      setState(() {});
    });
  }

  // 获取可用优惠券数量
  _discountsStatistics() {
    Api.discountsStatistics(successCallBack: (res) {
      _count = res['data']['canUse'];
      setState(() {});
    });
  }

  token() async {
    print(await sharedGetData('token'));
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _flag
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.red,
              title: Text('${_userInfo["nick"] ?? ''}'),
            ),
      backgroundColor: Colors.white,
      body: Container(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverToBoxAdapter(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Container(
                    width: double.infinity,
                    height: 130,
                    color: Colors.red,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(_userInfo['avatarUrl'] ?? 'https://dcdn.it120.cc/2021/03/02/ea71b830-c774-4497-8328-194a6b144018.jpg'),
                          ),
                        ),
                        Text(
                          '${_userInfo["nick"] ?? ''}',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  BorderListTileWidget(
                    leading: IconDatas.icontupian5(color: Style.rgba(220, 220, 220, 1), size: 22),
                    title: Text('个人资料'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      // then解决返回当前页面时的操作
                      NavigatorUtil.navigateTo(context, PageRouter.userInfoPage).then((val) => val ? getUserInfo() : null);
                    },
                  ),
                  BorderListTileWidget(
                    leading: IconDatas.icontupian3(color: Style.rgba(220, 220, 220, 1), size: 22),
                    title: Text('咖啡钱包'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  BorderListTileWidget(
                    leading: IconDatas.icontupian13(color: Style.rgba(220, 220, 220, 1), size: 22),
                    title: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('优惠券'),
                        Text(
                          '($_count)',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      NavigatorUtil.navigateTo(context, PageRouter.discountCouponPage);
                    },
                  ),
                  BorderListTileWidget(
                    leading: IconDatas.icontupian15(color: Style.rgba(220, 220, 220, 1), size: 22),
                    title: Text('兑换优惠'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  BorderListTileWidget(
                    leading: IconDatas.icontupian9(color: Style.rgba(220, 220, 220, 1), size: 22),
                    title: Text('发票管理'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  BorderListTileWidget(
                    leading: Icon(
                      Icons.settings,
                      color: Style.rgba(220, 220, 220, 1),
                    ),
                    title: Text('设置'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      NavigatorUtil.navigateTo(context, PageRouter.setPage);
                    },
                  ),
                  BorderListTileWidget(
                    leading: IconDatas.icontupian10(color: Style.rgba(220, 220, 220, 1)),
                    title: Text('帮助反馈'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
