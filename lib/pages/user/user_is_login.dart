import 'package:boil/network.dart';
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

  @override
  void initState() {
    super.initState();
    InitUserStatus();
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
          Stack(
            children: [
              Container(height: 200, color: Colors.blue[100]),
              Positioned(
                left: 10,
                right: 10,
                top: 90,
                bottom: 0,
                child: Align(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://blog.icepan.cloud/${GlobalState["userInfo"]["avatarId"]}.jpg"),
                    radius: 60,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(GlobalState["userInfo"]["bio"]),
          ),
          SizedBox(height: 10),
          ListTile(
            leading:
                Icon(Icons.notifications_active_outlined, color: Colors.blue),
            title: Text("消息"),
            onTap: () {
              Navigator.pushNamed(context, "/user/message");
            },
            trailing: Chip(label: Text(userStatus["msgCount"].toString())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.adjust, color: Colors.blue),
            title: Text("我的动态"),
            trailing: Chip(label: Text(userStatus["userBoilCount"].toString())),
            onTap: () async {
              Response resp = await dio
                  .get("/boil/list/user/${GlobalState['userInfo']['id']}");
              List tagBoilList = resp.data["data"];
              Navigator.pushNamed(context, "/boil/list",
                  arguments: {"boilList": tagBoilList});
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_outline_rounded, color: Colors.blue),
            title: Text("喜欢过的"),
            onTap: () {
              Navigator.pushNamed(context, "/boil/list",
                  arguments: {"boilList": []});
            },
            trailing: Chip(label: Text(userStatus["likeBoilCount"].toString())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article_outlined, color: Colors.blue),
            title: Text("评论过的"),
            onTap: () async {
              Response resp = await dio.get(
                  "/boil/list/user/${GlobalState["userInfo"]["id"]}/comment");
              List commentBoilList = resp.data["data"];
              Navigator.pushNamed(context, "/boil/list",
                  arguments: {"boilList": commentBoilList});
            },
            trailing: Chip(label: Text(userStatus["commentCount"].toString())),
          ),
          Divider(),
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
                    arguments: GlobalState["userInfo"]["bio"]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
