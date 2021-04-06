import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:flutter_luckin_coffee/tool/util.dart';

class EmailRegister extends StatefulWidget {
  EmailRegister({Key key}) : super(key: key);
  _EmailRegisterState createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _code = TextEditingController();
  bool _flag = true;
  Timer _timer;
  int _seconds = 60;
  @override
  void initState() {
    super.initState();
  }

  _time() {
    _timer = Timer(Duration(seconds: 1), () {
      _seconds--;
      setState(() {
        if (_seconds == 0) {
          _timer.cancel();
          _flag = true;
          _seconds = 60;
        } else {
          _time();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('邮箱注册'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
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
                  TextFormField(
                    controller: _password,
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
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _code,
                          style: TextStyle(
                            color: Color.fromRGBO(166, 166, 166, 1),
                          ),
                          decoration: InputDecoration(
                            hintText: ("请输入验证码"),
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
                          validator: (v) {
                            return v.trim().length > 5 ? null : "密码不能少于6位";
                          },
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (_flag) {
                            Api.mailCode(
                              pathParams: {'mail': _email.text},
                              successCallBack: (res) => {
                                EasyLoading.showSuccess('发送成功'),
                                _time(),
                                setState(() {
                                  _flag = false;
                                }),
                              },
                            );
                            return () {};
                          } else {
                            return null;
                          }
                        },
                        autofocus: true,
                        child: Text(
                          _flag ? '发送验证码' : "$_seconds秒后发送验证码",
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 40),
                      child: RaisedButton(
                        color: Color.fromRGBO(73, 194, 101, 1),
                        onPressed: () {
                          Api.mailRegister(
                            pathParams: {
                              'email': _email.text,
                              'code': _code.text,
                              'pwd': _password.text,
                            },
                            successCallBack: (res) => {
                              EasyLoading.showSuccess('注册成功'),
                              NavigatorUtil.navigateTo(context, PageRouter.login),
                            },
                          );
                        },
                        textColor: Colors.white,
                        child: Text("注册"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
