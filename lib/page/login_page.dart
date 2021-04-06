import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/http/dio_util.dart';
import 'package:flutter_luckin_coffee/provider/base_data.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/device_info.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  String _deviceId = '';
  String _deviceName = '';
  // 存验证码的key
  String _key;
  void initState() {
    super.initState();
    _deviceInfo();
    _verificationPic();
  }

  Future _deviceInfo() async {
    Map<String, dynamic> _info = await DeviceInfo.initPlatformState();
    _deviceId = _info['model'];
    _deviceName = _info['name'];
  }

  /*
   * 点击登录
   * 登录成功token存到本地并销毁登录页面跳入首页
   * */
  Future _login() async {
    // 先验证验证码是否正确
    Api.verificationPicCheck(
      pathParams: {'key': _key, 'code': _verificationCodeController.text},
      successCallBack: (res) {
        Api.login(
          pathParams: {
            'email': _userNameController.text,
            'pwd': _passwordController.text,
            'deviceId': _deviceId,
            'deviceName': _deviceName,
          },
          successCallBack: (res) {
            /// token存到本地
            sharedAddAndUpdate('token', String, res['data']['token']);
            // 获取用户详情
            Api.userDetail(
              successCallBack: (r) {
                Provider.of<BaseData>(context, listen: false).addUserInfo(r['data']['base']);
                NavigatorUtil.navigateTo(context, PageRouter.home, replace: true, clearStack: true);
              },
            );
          },
        );
      },
    );
  }

  Uint8List img;

  // 获取图片验证码
  Future _verificationPic() async {
    _key = DateTime.now().millisecondsSinceEpoch.toString();
    Dio _dio = new Dio();
    String path = NWApi.baseApi + "/verification/pic/get";
    try {
      String url = path;
      Response response = await _dio.get(url, options: Options(responseType: ResponseType.bytes), queryParameters: {'key': _key});
      final Uint8List bytes = await httpClientResponseBytes(response.data);
      img = bytes;
      setState(() {});
    } catch (e) {
      print("网络错误：" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.w),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                          width: 80.w,
                          height: 94.w,
                          child: Image.asset('lib/assets/images/logo1.png'),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _userNameController, //通过controller获取输入框内容
                          autofocus: false, //自动获取焦点
                          style: TextStyle(
                            color: Color.fromRGBO(166, 166, 166, 1),
                          ),
                          decoration: InputDecoration(
                            hintText: ("请输入邮箱"),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
                            ),
                            prefixIcon: Icon(Icons.attach_email, color: Color.fromRGBO(166, 166, 166, 1)),
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(166, 166, 166, 1),
                            ),
                          ),
                          validator: (v) {
                            return isEmail(v) ? null : "请输入正确的邮箱";
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(
                              color: Color.fromRGBO(166, 166, 166, 1),
                            ),
                            decoration: InputDecoration(
                              hintText: ("请输入密码"),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
                              ),
                              prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(166, 166, 166, 1)),
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(166, 166, 166, 1),
                              ),
                            ),
                            validator: (v) {
                              return v.trim().length > 5 ? null : "密码不能少于6位";
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10.w),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _verificationCodeController, //通过controller获取输入框内容
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Color.fromRGBO(166, 166, 166, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: ("验证码"),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)),
                                      ),
                                      prefixIcon: Icon(Icons.domain_verification, color: Color.fromRGBO(166, 166, 166, 1)),
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(166, 166, 166, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _verificationPic();
                                  },
                                  child: SizedBox(
                                    width: 120.w,
                                    child: img == null ? Text('') : Image.memory(img),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 25.w),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(height: 40),
                            child: RaisedButton(
                              color: Color.fromRGBO(73, 194, 101, 1),
                              onPressed: () {
                                print(_userNameController.text);
                                if ((_formKey.currentState as FormState).validate()) {
                                  _login();
                                }
                              },
                              textColor: Colors.white,
                              child: Text("登录"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.w),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(height: 40),
                            child: RaisedButton(
                              color: Color.fromRGBO(73, 194, 101, 1),
                              onPressed: () {},
                              textColor: Colors.white,
                              child: Text("QQ一键登录"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.w),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(height: 40),
                            child: RaisedButton(
                              color: Color.fromRGBO(73, 194, 101, 1),
                              onPressed: () {
                                NavigatorUtil.navigateTo(context, PageRouter.emailRegister);
                              },
                              textColor: Colors.white,
                              child: Text("邮箱注册"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
