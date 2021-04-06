import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';

class LocationUnit {
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
  BaiduLocation _baiduLocation;
  getLocation({Function successCallBack}) {
    // 开启定位
    _startLocation();
    _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      try {
        _baiduLocation = BaiduLocation.fromMap(result);
        successCallBack(_baiduLocation);
      } catch (e) {
        successCallBack(BaiduLocation.fromMap({}));
      }
      _stopLocation();
    });
  }

  /// 设置android端和ios端定位参数
  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("GCJ02"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();
    _locationPlugin.prepareLoc(androidMap, iosMap);
  }

  /// 启动定位
  void _startLocation() {
    if (null != _locationPlugin) {
      _setLocOption();
      _locationPlugin.startLocation();
    }
  }

  /// 停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

// 根据经纬度获取具体地址
  formattedAddress(double latitude, double longitude,
      {Function successCallBack}) async {
    Dio dio = Dio();
    Response response;
    response = await dio.get(
      'http://api.map.baidu.com/reverse_geocoding/v3/?ak=nspvZ4QXD0UgXY6QB0xDm6vK5GiOSXkZ&output=json&coordtype=gcj02ll&location=$latitude,$longitude',
    );
    Map data = jsonDecode(response.data);
    successCallBack(data);
  }

  // 根据经纬度获取距离
  /// origins 开始经纬度 纬度，经度 | 纬度，经度 destinations 结束经纬度 纬度，经度 | 纬度，经度
  getMeter(String origins, String destinations,
      {Function successCallBack}) async {
    Dio dio = Dio();
    Response response;
    response = await dio.get(
        'http://api.map.baidu.com/routematrix/v2/driving?output=json&ak=nspvZ4QXD0UgXY6QB0xDm6vK5GiOSXkZ',
        queryParameters: {'origins': origins, 'destinations': destinations});
    Map data = jsonDecode(response.data);
    successCallBack(data['result']);
  }
}
