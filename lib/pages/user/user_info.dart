import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info_component.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  int userId;
  UserInfoPage(this.userId, {Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
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
  bool isFollow = false;

  @override
  void initState() {
    super.initState();
    InitUserInfo();
  }

  void InitUserInfo() async {
    Response resp = await dio.get("/user/info/${widget.userId}");
    setState(() {
      this.userInfo = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                InitUserInfo();
              })
        ],
      ),
      body: Column(children: [
        UserInfoComponent(userInfo),
        RaisedButton.icon(
          onPressed: () {
            if (GlobalState['isLogin'] == false) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/user", (route) => route == null);
              return;
            }
            setState(() {
              userInfo['isFollow'] = !userInfo['isFollow'];
            });
          },
          icon: Icon(userInfo['isFollow'] ? Icons.face : Icons.add),
          color: userInfo['isFollow'] ? Colors.blue[200] : Colors.grey[300],
          label: Text(userInfo['isFollow'] ? "取消关注" : "关注"),
        )
      ]),
    );
  }
}
