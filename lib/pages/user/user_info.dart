import 'package:boil/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  Map userMap;
  UserInfoPage(this.userMap, {Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState(this.userMap);
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map userStatus = {"msgCount": 0, "userBoilCount": 0, "likeBoilCount": 0};
  Map userMap;
  _UserInfoPageState(this.userMap);

  @override
  void initState() {
    print("userinfo....");
    super.initState();
    InitUserStatus();
  }

  void InitUserStatus() async {
    Response resp = await dio.get("/user/status/${userMap['userId']}");
    setState(() {
      this.userStatus = resp.data["data"];
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
                InitUserStatus();
              })
        ],
      ),
      body: Container(
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
                      backgroundImage: NetworkImage(
                          "https://blog.icepan.cloud/${userMap['userAvatarId']}.jpg"),
                      radius: 60,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(userMap["userBio"]),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.adjust, color: Colors.blue),
              title: Text("他的动态"),
              trailing:
                  Chip(label: Text(userStatus["userBoilCount"].toString())),
              onTap: () async {
                Response resp =
                    await dio.get("/boil/list/user/${userMap['userId']}");
                List userBoilList = resp.data["data"];
                Navigator.pushNamed(context, "/boil/list",
                    arguments: {"boilList": userBoilList});
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star_outline_rounded, color: Colors.blue),
              title: Text("他喜欢过的"),
              onTap: () async {
                Response resp =
                    await dio.get("/boil/user/likes/${userMap['userId']}");
                List tagBoilList = resp.data["data"];
                Navigator.pushNamed(context, "/boil/list",
                    arguments: {"boilList": tagBoilList});
              },
              trailing:
                  Chip(label: Text(userStatus["likeBoilCount"].toString())),
            ),
            ListTile(
              leading: Icon(Icons.article_outlined, color: Colors.blue),
              title: Text("评论过的"),
              onTap: () async {
                Response resp = await dio
                    .get("/boil/list/user/${userMap['userId']}/comment");
                List commentBoilList = resp.data["data"];
                Navigator.pushNamed(context, "/boil/list",
                    arguments: {"boilList": commentBoilList});
              },
              trailing:
                  Chip(label: Text(userStatus["commentCount"].toString())),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
