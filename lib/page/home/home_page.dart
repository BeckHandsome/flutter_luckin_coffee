import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_luckin_coffee/page/home/home_index_page.dart';
import 'package:flutter_luckin_coffee/page/menu/menu_page.dart';
import 'package:flutter_luckin_coffee/page/my/my_page.dart';
import 'package:flutter_luckin_coffee/page/order/order_page.dart';
import 'package:flutter_luckin_coffee/page/shopping/shopping_cart_page.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/tool/Icon.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController _tabController;
  bool flag = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: currentIndex, length: 5, vsync: this);
    // 避免页面未渲染完毕就调用状态组件里面的异步
    Future.delayed(Duration(milliseconds: 200), () {
      Provider.of<BaseData>(context, listen: false).addCartNumber();
    });
    locations();
  }

  // 获取当前定位
  locations() async {
    flag = await getPermission(Permission.location);
    if (flag) {
      Provider.of<BaseData>(context, listen: false).addLocationInfo();
    }
  }

  // 点击菜单
  _getCurrentIndex(int indexValue) {
    currentIndex = indexValue;
    setState(() {});
    _tabController.animateTo(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), //禁止滚动
        controller: _tabController,
        children: [
          HomeIndexPage(
            parentFun: _getCurrentIndex,
          ),
          MenuPage(),
          OrderPage(),
          ShoppingCartPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: Consumer<BaseData>(
        builder: (BuildContext context, BaseData value, Widget child) {
          String _cartNumber = '';
          if (value.cartNumber == 0 || value.cartNumber == null) {
            _cartNumber = '';
          } else if (value.cartNumber > 99) {
            _cartNumber = '99+';
          } else {
            _cartNumber = value.cartNumber.toString();
          }
          return ConvexAppBar.badge(
            {
              3: '$_cartNumber',
            },
            // initialActiveIndex: currentIndex,
            controller: _tabController,
            onTap: (int index) {
              _getCurrentIndex(index);
            },
            elevation: 0,
            curveSize: 0,
            height: 55,
            style: TabStyle.react,
            color: Style.rgba(153, 153, 153, 1),
            activeColor: Style.rgba(255, 85, 26, 1),
            backgroundColor: Style.rgba(255, 255, 255, 1),
            badgeMargin: EdgeInsets.only(bottom: 20, left: 30),
            items: [
              TabItem(
                title: "首页",
                icon: IconDatas.iconlogoNotText(),
                isIconBlend: true,
              ),
              TabItem(
                title: "菜单",
                icon: IconDatas.iconcaidan(),
                isIconBlend: true,
              ),
              TabItem(
                title: "订单",
                icon: IconDatas.iconorder(),
                isIconBlend: true,
              ),
              TabItem(
                title: "购物车",
                icon: IconDatas.icongouwuche(),
                isIconBlend: true,
              ),
              TabItem(
                title: "我的",
                icon: IconDatas.iconmine(),
                isIconBlend: true,
              ),
            ],
          );
        },
      ),
    );
  }
}
