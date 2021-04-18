import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:boil/network.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnLoginComponent extends StatefulWidget {
  UnLoginComponent({Key key}) : super(key: key);

  @override
  _UnLoginComponentState createState() => _UnLoginComponentState();
}

class _UnLoginComponentState extends State<UnLoginComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 100),
          Center(
            child: Container(
              width: 80,
              height: 80,
              child: new CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Text(
                  "可爱的头像",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            child: Card(
              child: LoginComponent(),
            ),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          )
        ],
      ),
    );
  }
}

class LoginComponent extends StatefulWidget {
  LoginComponent({Key key}) : super(key: key);

  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "用户名",
              hintText: "用户名",
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (val) {
              this.username = val;
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "密码",
              hintText: "您的登录密码",
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            onChanged: (val) {
              this.password = val;
            },
          ),
          SizedBox(height: 40.0),
          Wrap(
            children: [
              RaisedButton(
                color: Colors.blue[100],
                child: Text("登录"),
                onPressed: () async {
                  LoadingDialog.show(context);
                  if (this.username == "" || this.password == "") {
                    LoadingDialog.hide(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("账户或则密码不能为空!"),
                      ),
                    );
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    Response resp;
                    try {
                      resp = await dio.post(
                        "/user/login",
                        data: {"username": username, "password": password},
                      );
                      LoadingDialog.hide(context);
                      GlobalState["isLogin"] = true;
                      GlobalState["userInfo"] = resp.data["data"];
                      GlobalState["token"] = resp.data["token"];
                      prefs.setBool("isLogin", true);
                      prefs.setString(
                          "userInfo", jsonEncode(GlobalState["userInfo"]));
                      prefs.setString("token", resp.data["token"]);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/user", (route) => route == null);
                    } catch (e) {
                      LoadingDialog.hide(context);
                      prefs.setBool("isLogin", false);
                      prefs.remove("userInfo");
                      prefs.remove("token");
                      GlobalState["isLogin"] = false;
                      GlobalState["userInfo"] = "";
                      GlobalState["token"] = "";
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("登录失败!"),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(width: 50),
              RaisedButton(
                child: Text("注册"),
                color: Colors.green[200],
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("敬请期待~"),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
