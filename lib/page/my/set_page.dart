import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';
import 'package:flutter_luckin_coffee/widget/widget_border_list_title.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

class SetPage extends StatefulWidget {
  SetPage({Key key}) : super(key: key);
  @override
  _SetPageState createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  String _cacheSizeStr = '';
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );
  @override
  void initState() {
    super.initState();
    loadCache();
    _initPackageInfo();
  }

  void _outLogin() {
    Api.loginOut(
      successCallBack: (res) => {
        sharedDeleteData('token'),
        NavigatorUtil.navigateTo(context, PageRouter.login, replace: true, clearStack: true),
      },
    );
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  ///获取缓存（加载缓存）
  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    tempDir.list(followLinks: false, recursive: true).listen((file) {
      //打印每个缓存文件的路径
      print(file.path);
    });
    print('临时目录大小: ' + value.toString());
    setState(() {
      _cacheSizeStr = _renderSize(value); // _cacheSizeStr用来存储大小的值
    });
  }

  ///循环计算文件的大小（递归）
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null) for (final FileSystemEntity child in children) total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  /// 格式化缓存文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  /// 通过 path_provider 得到缓存目录，然后通过递归的方式，删除里面所有的文件。
  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    EasyLoading.showSuccess('清除缓存成功');
    setState(() {});
    Navigator.pop(context);
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        title: Text(
          '设置',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: ListView(
          children: [
            BorderListTileWidget(
              title: Text('上传图片和视频'),
              onTap: () {
                NavigatorUtil.navigateTo(context, PageRouter.uploadFilesPage);
              },
            ),
            BorderListTileWidget(
              title: Text('我的收获地址'),
            ),
            BorderListTileWidget(
              title: Text('账户与安全'),
            ),
            BorderListTileWidget(
              title: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('清除缓存'),
                  Text('$_cacheSizeStr'),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("是否清除缓存"),
                    actions: [
                      FlatButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("确定"),
                        onPressed: () {
                          _clearCache();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            BorderListTileWidget(
              title: Text('App当前版本号'),
              trailing: Text('${_packageInfo.version}'),
            ),
            MaterialButton(
              color: Colors.blue,
              minWidth: double.infinity,
              height: 50,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text("退出登录"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("是否退出登录"),
                    actions: [
                      FlatButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("确定"),
                        onPressed: () {
                          _outLogin();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
