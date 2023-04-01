import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../common/network.dart';
import 'package:dio/dio.dart';
class RegisterRoute extends StatefulWidget {
  const RegisterRoute({Key? key}) : super(key: key);

  @override
  State<RegisterRoute> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwd2Controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _nameAutoFocus = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("注册")),
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
                        return v == null || v
                            .trim()
                            .isNotEmpty ? null : "用户名不能为空";
                      }),

                  TextFormField(
                      autofocus: !_nameAutoFocus,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "邮箱",
                        hintText: "邮箱",
                        prefixIcon: Icon(Icons.email),
                      ),
                      // 校验邮箱
                      validator: (v) {
                        String regexEmail = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
                        if (v == null || v
                            .trim()
                            .isEmpty) {
                          return "邮箱不能为空";
                        }
                        if (!RegExp(regexEmail).hasMatch(v)) {
                          return "邮箱格式不正确";
                        }
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
                      return v == null || v
                          .trim()
                          .isNotEmpty ? null : "密码不能为空";
                    },
                  ),

                  TextFormField(
                    controller: _pwd2Controller,
                    autofocus: !_nameAutoFocus,
                    decoration: InputDecoration(
                        labelText: "确认密码",
                        hintText: "确认密码",
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
                      if (v == null || v
                          .trim()
                          .isEmpty) {
                        return "密码不能为空";
                      }
                      if (v != _pwdController.text) {
                        return "两次密码不一样";
                      }
                    },
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child:
                        TextFormField(
                        controller: _codeController,
                        autofocus: !_nameAutoFocus,
                        decoration: InputDecoration(
                          hintText: "邮箱验证码",
                          prefixIcon: Icon(Icons.code),),
                      ),
                      ),
                      ElevatedButton(
                            onPressed: _sendCode,
                            child: Text("发送验证码"),
                          ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 55.0),
                      child: ElevatedButton(
                        // color: Theme.of(context).primaryColor,
                        onPressed: _onRegister,
                        // textColor: Colors.white,
                        child: Text("注册"),
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

    void _sendCode() async {
      var response;
      // 先验证各个表单字段是否合法
      if ((_formKey.currentState as FormState).validate()) {
        try {
          EasyLoading.show(status: '发送中...');
          response = await sendcode(_emailController.text);
        } on DioError catch (e) {
          //登录失败则提示
          if (e.response?.statusCode == 204) {
            EasyLoading.showToast("邮件已发送");
          } else {
            EasyLoading.showToast(e.toString());
          }
        } finally {
          // 隐藏loading框
          EasyLoading.dismiss();
        }
        //登录成功则返回
        if (response == 200) {
          EasyLoading.showToast("发送成功，30分钟有效");
        }
      }
    }

  void _onRegister() async {
    var response;
    // 先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      try {
        EasyLoading.show(status: '注册中...');
        response = await register(_unameController.text, _pwdController.text, _emailController.text, _codeController.text);
      } on DioError catch (e) {
        //注册失败则提示
        if (e.response?.statusCode == 400) {
          EasyLoading.showToast("验证码不正确");
        } else {
          EasyLoading.showToast(e.toString());
        }
      } finally {
        // 隐藏loading框
        EasyLoading.dismiss();
      }
      //登录成功则返回
      if (response == 201) {
        EasyLoading.showToast("注册成功");
        Navigator.of(context).pop();
      }
    }
  }
  }
