import 'dart:convert';

import 'package:boil/model/user.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = false;
  UserInfo userInfo = UserInfo();
  @override
  void initState() {
    super.initState();
    InitLoginState();
  }

  void InitLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool("isLogin");
      if (isLogin) {
        Map<String, dynamic> userMap = jsonDecode(prefs.getString("userInfo"));
        userInfo.ID = userMap["id"];
        userInfo.UserName = userMap["username"];
        userInfo.AvatarId = userMap["avatarId"];
        userInfo.Bio = userMap["bio"];
      }
    });
  }

  List<Widget> unLoginComponents = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(height: 200, color: Colors.green[300]),
              Positioned(
                left: 10,
                right: 10,
                top: 90,
                bottom: 0,
                child: Align(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage("https://blog.icepan.cloud/avatar.jpg"),
                    radius: 60,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(this.userInfo.Bio),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text("消息"),
            onTap: () {
              Navigator.pushNamed(context, "/user/message");
            },
            trailing: Chip(label: Text("1")),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.apps_sharp, color: Colors.blue),
            title: Text("我的动态"),
            trailing: Chip(label: Text("1")),
            onTap: () {
              Navigator.pushNamed(context, "/boil/list");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_outlined, color: Colors.blue),
            title: Text("喜欢过的"),
            onTap: () {
              Navigator.pushNamed(context, "/boil/list");
            },
            trailing: Chip(label: Text("12")),
          ),
          Divider(),
          SizedBox(height: 40.0),
          SizedBox(
            height: 50.0,
            width: 400.0,
            child: RaisedButton(
              child: Text("退出"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLogin", false);
                Navigator.pop(context);
                Navigator.pushNamed(context, "/user");
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
                      prefs.setBool("isLogin", true);
                      prefs.setString(
                          "userInfo", jsonEncode(resp.data["data"]));
                      prefs.setString("userToken", resp.data["token"]);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/user");
                    } catch (e) {
                      LoadingDialog.hide(context);
                      prefs.setBool("isLogin", false);
                      prefs.remove("userInfo");
                      prefs.remove("userToken");
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

class UserMessagePage extends StatefulWidget {
  UserMessagePage({Key key}) : super(key: key);

  @override
  _UserMessagePageState createState() => _UserMessagePageState();
}

class _UserMessagePageState extends State<UserMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
      ),
      body: Text("用户消息"),
    );
  }
}
