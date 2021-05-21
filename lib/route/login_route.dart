import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid/bean/user_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';

import '../main.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginRoute> {

  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: _getWidget(),
    );
  }

  Widget _getWidget(){
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//      //设置背景图片
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: AssetImage("imgs/ic_skin_01.jpg"),
//          fit: BoxFit.fill
//        )
//      ),
      child: Form(
        key: _formKey,
        autovalidate: true, //开启自动校验
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _unameController,
              decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "用户名或邮箱",
                  icon: Icon(Icons.person)
              ),
              validator:(v) {
                return v.trim().length > 0 ? null : "用户名不能为空";
              }
            ),
            TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "输入密码",
                    icon: Icon(Icons.lock)
                ),
                obscureText: true,
                //校验密码
                validator: (v) {
                  return v.trim().length > 0 ? null : "密码不能为空";
                }
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("登录"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: (){
                        //在这里不能通过此方式获取FormState，context不对
                        //print(Form.of(context));

                        // 通过_formKey.currentState 获取FormState后，
                        // 调用validate()方法校验用户名密码是否合法，校验
                        // 通过后再提交数据。
                        print("登录回调函数");
                        if((_formKey.currentState as FormState).validate()){
                          //验证通过提交数据
                          _login(_unameController.text, _pwdController.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _login(String user,String pwd) async {
    try{
      var loginResponse = await DioHelper.getInstance().post(ApiServer.LOGIN,data: {"username":user,"password":pwd});
      var userMap = json.decode(loginResponse.toString());
      var userEntity = UserEntity.fromJson(userMap);
      if (userEntity.errorCode == 0) {
        print("登录成功~");
        //跳转并关闭当前页面
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
              (route) => route == null,
        );
      } else {
        print("登录失败:" + userMap['errorMsg']);
      }
    }catch(e) {
      return print(e);
    }
  }
}