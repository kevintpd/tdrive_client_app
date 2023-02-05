import 'dart:convert';

import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../common/global.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../common/network.dart';
import '../../common/server_spec.dart' as server;
import 'package:dio/dio.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录"),automaticallyImplyLeading: false,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                children: <Widget>[
                  TextFormField(
                      autofocus: _nameAutoFocus,
                      controller: _unameController,
                      decoration: InputDecoration(
                        labelText: "账号",
                        hintText: "账号",
                        prefixIcon: Icon(Icons.person),
                      ),
                      // 校验用户名（不能为空）
                      validator: (v) {
                        return v == null || v.trim().isNotEmpty ? null : "用户名不能为空";
                      }),
                  TextFormField(
                    controller: _pwdController,
                    autofocus: !_nameAutoFocus,
                    decoration: InputDecoration(
                        labelText: "密码",
                        hintText: "密码",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              pwdShow ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              pwdShow = !pwdShow;
                            });
                          },
                        )),
                    obscureText: !pwdShow,
                    //校验密码（不能为空）
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : "密码不能为空";
                    },
                  ),
                  Row(
                    children: [
                      Text("没有账号？"),
                      GestureDetector(
                        child: Text(
                          '点击注册',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () => Navigator.of(context).pushNamed("register"),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 55.0),
                      child: ElevatedButton(
                        // color: Theme.of(context).primaryColor,
                        onPressed: _onLogin,
                        // textColor: Colors.white,
                        child: Text("登录"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    var response;
    // 先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      try {
        //保存token至prefs
        await prefs.setString('token',
            'Basic ${base64Encode(utf8.encode('${_unameController.text}:${_pwdController.text}'))}');
        print(server.headers);
        EasyLoading.show(status: 'Loading...');
        response = await login();
      } on DioError catch (e) {
        //登录失败则提示
        if (e.response?.statusCode == 403) {
          EasyLoading.showToast("账号或密码错误");
        } else {
          EasyLoading.showToast(e.toString());
        }
      } finally {
        // 隐藏loading框
        EasyLoading.dismiss();
      }
      //登录成功则返回
      if (response == 200) {
        DateTime dateTime = DateTime.now();
        prefs.setString('username', _unameController.text);
        prefs.setString('lastLogin', dateTime.toString().substring(0, 19));

        Navigator.of(context).pop();
      }
    }
  }
}
