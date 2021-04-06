import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/tool/Icon.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_luckin_coffee/widget/widget_future_builder.dart';
import 'package:flutter_luckin_coffee/tool/location.dart';
import 'package:provider/provider.dart';

class CheckShopPage extends StatefulWidget {
  CheckShopPage({Key key}) : super(key: key);
  _CheckShopPageState createState() => _CheckShopPageState();
}

class _CheckShopPageState extends State<CheckShopPage> {
  @override
  void initState() {
    super.initState();
  }

  // 获取门店列表
  Future subshopList() async {
    return Api.subshopList(successCallBack: (res) => res);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.rgba(239, 239, 239, 1),
      appBar: AppBar(
        title: Text(
          '门店',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Style.rgba(239, 239, 239, 1),
        elevation: 0,
        iconTheme: IconThemeData.fallback(),
      ),
      body: WidgetFutureBuilder(
        future: subshopList(),
        child: (res) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Provider.of<BaseData>(context, listen: false).addShopDetail(res[index]['id'].toString());
                  Navigator.of(context).pop();
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Style.rgba(136, 175, 213, 1),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Text(
                                        '瑞幸咖啡',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${res[index]["name"]}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DistanceText(
                              latitude: res[index]['latitude'],
                              longitude: res[index]['longitude'],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconDatas.icontubiao5(
                              size: 12,
                              color: Style.rgba(166, 166, 166, 1),
                            ),
                            Text(
                              '${res[index]["openingHours"]}',
                              style: TextStyle(
                                color: Style.rgba(166, 166, 166, 1),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Style.rgba(166, 166, 166, 1),
                            ),
                            LocationText(
                              latitude: res[index]['latitude'],
                              longitude: res[index]['longitude'],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: res.length ?? 1,
          );
        },
      ),
    );
  }
}

class DistanceText extends StatefulWidget {
  DistanceText({
    Key key,
    this.latitude,
    this.longitude,
  }) : super(key: key);
  _DistanceTextState createState() => _DistanceTextState();
  final double latitude;
  final double longitude;
}

class _DistanceTextState extends State<DistanceText> {
  String distance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseData>(builder: (BuildContext context, BaseData baseData, _) {
      BaiduLocation locationInfo = baseData.locationInfo;
      if (locationInfo != null) {
        String origins = '${locationInfo.latitude},${locationInfo.longitude}';
        String destinations = '${widget.latitude},${widget.longitude}';
        LocationUnit().getMeter(
          origins,
          destinations,
          successCallBack: (List result) {
            distance = result[0]['distance']['text'];
            setState(() {});
          },
        );
      }
      return Text(
        '${distance ?? ''}',
        style: TextStyle(
          color: Style.rgba(166, 166, 166, 1),
          fontSize: 12,
        ),
      );
    });
  }
}

class LocationText extends StatefulWidget {
  LocationText({Key key, this.latitude, this.longitude}) : super(key: key);
  final double latitude; // 纬度
  final double longitude; // 经度
  _LocationTextState createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText> {
  String formattedAddress = '';
  @override
  void initState() {
    super.initState();
    LocationUnit().formattedAddress(
      widget.latitude,
      widget.longitude,
      successCallBack: (Map res) {
        setState(() {
          formattedAddress = res['result']['formatted_address'] ?? '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedAddress,
      style: TextStyle(
        color: Style.rgba(166, 166, 166, 1),
        fontSize: 12,
      ),
    );
  }
}
