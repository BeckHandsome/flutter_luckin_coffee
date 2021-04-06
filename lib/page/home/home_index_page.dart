import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/Icon.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_luckin_coffee/widget/widget_border_bottom_list_tile.dart';
import 'package:flutter_luckin_coffee/widget/widget_swiper.dart';
import 'package:flutter_luckin_coffee/widget/widget_switch_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/tool/location.dart';

class HomeIndexPage extends StatefulWidget {
  HomeIndexPage({Key key, this.parentFun}) : super(key: key);
  final Function parentFun;
  @override
  _HomeIndexPageState createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeIndexPage> {
  List<Map> bannner = [
    {
      'img': 'lib/assets/images/home/swiper1.jpg',
    },
    {
      'img': 'lib/assets/images/home/swiper2.jpg',
    },
    {
      'img': 'lib/assets/images/home/swiper3.jpg',
    }
  ];

  // 注意在 build 里面调用 Provider.of<ATheme>(context); 就会自动注册监听；也不用担心重复注册；

  @override
  void initState() {
    super.initState();
    subshopList();
  }

  double currentLatitude;
  double currentLongitude;
  BaiduLocation locationResult;

// 获取门店列表
  subshopList() {
    Api.subshopList(
      successCallBack: (res) {
        Provider.of<BaseData>(context, listen: false).addShopDetail(res['data'][0]['id'].toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 208.w,
            flexibleSpace: FlexibleSpaceBar(
              background: // 轮播图
                  Padding(
                padding: EdgeInsets.all(0),
                child: WidgetSwiper(
                  bannner: bannner,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int i) {
                return Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Column(
                    children: [
                      ShopDetail(),
                      BorderBottomListTileWidget(
                        title: '现在下单',
                        subtitle: 'ORDER NOW',
                        trailing: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Style.borderAll(),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: IconDatas.icontupian3(size: 24.w, color: Style.rgba(99, 71, 58, 1)),
                          ),
                        ),
                        onTap: () {
                          widget.parentFun(1);
                        },
                      ),
                      BorderBottomListTileWidget(
                        title: '咖啡钱包',
                        subtitle: 'COFFRR WALLET',
                        trailing: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Style.borderAll(),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: IconDatas.icontupian14(size: 24.w, color: Style.rgba(99, 71, 58, 1)),
                          ),
                        ),
                        onTap: () {},
                      ),
                      BorderBottomListTileWidget(
                        title: '送Ta咖啡',
                        subtitle: 'SEND COFFEE',
                        trailing: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Style.borderAll(),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: IconDatas.icontupian15(size: 24.w, color: Style.rgba(99, 71, 58, 1)),
                          ),
                        ),
                        onTap: () {},
                      ),
                      BorderBottomListTileWidget(
                        title: '企业账户',
                        subtitle: 'ENTERPRISE ACCOUNT',
                        trailing: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Style.borderAll(),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: IconDatas.icontupian2(size: 24.w, color: Style.rgba(99, 71, 58, 1)),
                          ),
                        ),
                        isBottom: false,
                        onTap: () {},
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 55.w,
                        child: Image.asset(
                          'lib/assets/images/home/bottom_bar.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ShopDetail extends StatefulWidget {
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  String distance;
  bool currentValue = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<BaseData>(
      builder: (BuildContext context, BaseData baseData, _) {
        BaiduLocation locationInfo = baseData.locationInfo;
        Map shopDetail = baseData.baseData['shopDetail'];
        if (locationInfo != null && shopDetail != null) {
          String origins = '${locationInfo.latitude},${locationInfo.longitude}';
          String destinations = '${shopDetail['latitude']},${shopDetail['longitude']}';
          LocationUnit().getMeter(
            origins,
            destinations,
            successCallBack: (List result) {
              distance = result != null ? result[0]['distance']['text'] : '';
              setState(() {});
            },
          );
        }
        return BorderBottomListTileWidget(
          leading: Icon(
            Icons.location_on,
            size: 20,
            color: Style.rgba(128, 128, 128, 1),
          ),
          title: shopDetail['name'],
          subtitle: '距您${distance ?? ''}',
          onTap: () {
            NavigatorUtil.navigateTo(
              context,
              PageRouter.checkShopPage,
            );
          },
          trailing: SwitchButton(
            width: 90.w,
            height: 36.w,
            selectLable: '自提',
            unSelectLable: '外送',
            unSelectColor: Colors.white,
            currentValue: currentValue,
            onChanged: (currentValue) {
              currentValue = currentValue;
            },
          ),
        );
      },
    );
  }
}
