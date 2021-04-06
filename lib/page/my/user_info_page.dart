import 'dart:io';

import 'package:city_pickers/city_pickers.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/widget/widget_avatar.dart';
import 'package:flutter_luckin_coffee/widget/widget_border_list_title.dart';
import 'package:flutter_luckin_coffee/widget/widget_select.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map _userInfo = {};
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _nike = TextEditingController();
  List _sexList = [
    {
      'name': '未知',
      'id': 0,
    },
    {
      'name': '男',
      'id': 1,
    },
    {'name': '女', 'id': 2}
  ];
  int _currentSex = 0;
  String _birthday = '';
  String _city = '';
  String _province = '';
  String _avatarUrl = '';
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  // 获取个人信息
  getUserInfo() {
    Api.userDetail(successCallBack: (res) {
      _userInfo = res['data']['base'];
      _nike.text = _userInfo['nick'] ?? "";
      _currentSex = _userInfo['gender'] ?? 0;
      _birthday = _userInfo['birthday'] ?? "";
      _city = _userInfo['city'] ?? "";
      _province = _userInfo['province'] ?? "";
      _avatarUrl = _userInfo['avatarUrl'] ?? '';
      setState(() {});
    });
  }

  _userInfoEdit() async {
    Api.userInfoEdit(
      pathParams: {
        'city': _city,
        'province': _province,
        'nick': _nike.text,
        'gender': _currentSex,
        'birthday': _birthday,
        "avatarUrl": _avatarUrl,
      },
      successCallBack: (res) {
        Navigator.pop(context, true);
      },
    );
  }

  Future<FormData> _formData(path, name) async {
    return FormData.fromMap({
      "upfile": await MultipartFile.fromFile(path, filename: name),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('个人信息'),
        actions: [
          GestureDetector(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  '保存',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            onTap: () {
              _userInfoEdit();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Flex(
              direction: Axis.vertical,
              children: [
                BorderListTileWidget(
                  title: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text('头像'),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(_avatarUrl != '' ? _avatarUrl : 'https://dcdn.it120.cc/2021/03/02/ea71b830-c774-4497-8328-194a6b144018.jpg'),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    showSelectAvatar(
                      context,
                      success: (File file) async {
                        String path = file.path;
                        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
                        FormData _formDatas = await _formData(path, name);
                        Api.uploadFile(
                          formData: _formDatas,
                          successCallBack: (res) {
                            setState(() {
                              _avatarUrl = res['data']['url'];
                            });
                          },
                        );
                      },
                    );
                  },
                ),
                BorderListTileWidget(
                  title: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text('昵称'),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _nike,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Text('${_userInfo['nick'] ?? null}'),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                BorderListTileWidget(
                  title: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text('所在地'),
                      Text('$_province  $_city'),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    CityPickers.showCityPicker(context: context, showType: ShowType.pc).then((value) {
                      _city = value.cityName;
                      _province = value.provinceName;
                      setState(() {});
                    });
                  },
                ),
                BorderListTileWidget(
                  title: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text('生日'),
                      Text('$_birthday'),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    DatePicker.showDatePicker(context, onConfirm: (date) {
                      _birthday = formatDate(date, [yyyy, '-', mm, '-', dd]);
                      setState(() {});
                    }, locale: LocaleType.zh);
                  },
                ),
                BorderListTileWidget(
                  title: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text('性别'),
                      Text('${_sexList[_currentSex]['name'] ?? '未知'}'),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    SelectWidget.showSelect(
                      context,
                      title: '性别',
                      data: _sexList,
                      initialId: _currentSex.toString(),
                      onSuccess: (context, val) {
                        _currentSex = val['id'];
                        Navigator.pop(context);
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
