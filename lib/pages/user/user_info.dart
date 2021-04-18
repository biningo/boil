import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_list.dart';
import 'package:boil/pages/boil/boil_list_user.dart';
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
        body: UserInfoComponent(this.userMap, this.userStatus));
  }
}

class UserInfoComponent extends StatelessWidget {
  Map userStatus;
  Map userMap;
  UserInfoComponent(this.userMap, this.userStatus, {Key key}) : super(key: key);

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
            title: Text("动态"),
            trailing: Chip(label: Text(userStatus["userBoilCount"].toString())),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BoilListUserPage("/boil/list/user/${userMap['userId']}"),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_outline_rounded, color: Colors.blue),
            title: Text("喜欢过的"),
            onTap: () async {
              Response resp =
                  await dio.get("/boil/user/likes/${userMap['userId']}");
              List likeBoilList = resp.data["data"];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoilListPage(likeBoilList),
                ),
              );
            },
            trailing: Chip(label: Text(userStatus["likeBoilCount"].toString())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article_outlined, color: Colors.blue),
            title: Text("评论过的"),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BoilListUserPage(
                        "/boil/list/user/${userMap['userId']}/comment")),
              );
            },
            trailing: Chip(label: Text(userStatus["commentCount"].toString())),
          ),
          Divider(),
        ],
      ),
    );
  }
}
