import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info.dart';
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
  Map userStatus = {"msgCount": 0, "userBoilCount": 0, "likeBoilCount": 0};
  Map userMap;
  _IsLoginComponentState() {
    userMap = {
      "userBio": GlobalState["userInfo"]["bio"],
      "userId": GlobalState["userInfo"]["id"],
      "userAvatarId": GlobalState["userInfo"]["avatarId"]
    };
  }

  @override
  void initState() {
    super.initState();
    InitUserStatus();
  }

//转到其它页面
  @override
  void deactivate() {
    print("Home------------------deeeeeee");
  }

  void InitUserStatus() async {
    Response resp =
        await dio.get("/user/status/${GlobalState['userInfo']['id']}");
    setState(() {
      this.userStatus = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          UserInfoComponent(this.userMap, userStatus),
          ListTile(
            leading:
                Icon(Icons.notifications_active_outlined, color: Colors.blue),
            title: Text("消息"),
            onTap: () {
              Navigator.pushNamed(context, "/user/message");
            },
            trailing: Chip(label: Text(userStatus["msgCount"].toString())),
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
                    .then((value) => {
                          setState(() {
                            this.userMap["userBio"] = value;
                          })
                        });
              },
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 50.0,
            width: 300.0,
            child: RaisedButton(
              child: Text("刷新"),
              onPressed: () async {
                InitUserStatus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
