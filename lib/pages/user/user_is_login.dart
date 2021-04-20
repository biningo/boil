import 'dart:convert';
import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info_component.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsLoginComponent extends StatefulWidget {
  IsLoginComponent({Key key}) : super(key: key);

  @override
  _IsLoginComponentState createState() => _IsLoginComponentState();
}

class _IsLoginComponentState extends State<IsLoginComponent> {
  Map userInfo = {
    "id": 0,
    "isFollow": false,
    "followerCount": 0,
    "followingCount": 0,
    "boilCount": 0,
    "likeBoilCount": 0,
    "commentBoilCount": 0,
    "bio": "",
    "username": "",
    "avatarId": 0,
  };
  @override
  void initState() {
    super.initState();
    InitUserInfo();
  }

  void InitUserInfo() async {
    Response resp =
        await dio.get("/user/info/${GlobalState['userInfo']['id']}");
    setState(() {
      userInfo = resp.data['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          UserInfoComponent(userInfo),
          ListTile(
            leading:
                Icon(Icons.notifications_active_outlined, color: Colors.blue),
            title: Text("消息"),
            onTap: () {
              Navigator.pushNamed(context, "/user/message");
            },
            trailing: Chip(label: Text("0")),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            height: 50.0,
            width: 300.0,
            child: RaisedButton(
              child: Text("退出"),
              onPressed: () async {
                GlobalState["isLogin"] = false;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLogin", false);
                prefs.remove("userInfo");
                prefs.remove("token");
                GlobalState["userInfo"] = "";
                GlobalState["token"] = "";
                Navigator.pushNamedAndRemoveUntil(
                    context, "/user", (route) => route == null);
              },
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 50.0,
            width: 300.0,
            child: RaisedButton(
              child: Text("编辑个性签名"),
              onPressed: () async {
                Navigator.pushNamed(context, "/user/edit",
                        arguments: GlobalState["userInfo"]["bio"])
                    .then((value) async {
                  setState(() {
                    userInfo['bio'] = value;
                  });
                  GlobalState['userInfo']['bio'] = value;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(
                      "userInfo", jsonEncode(GlobalState['userInfo']));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
