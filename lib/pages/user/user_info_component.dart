import 'package:boil/pages/boil/boil_list.dart';
import 'package:boil/pages/follow/follow_user_list.dart';
import 'package:flutter/material.dart';

class UserInfoComponent extends StatelessWidget {
  Map userInfo;
  UserInfoComponent(this.userInfo, {Key key}) : super(key: key);

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
                        "https://blog.icepan.cloud/${userInfo['avatarId']}.jpg"),
                    radius: 60,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(userInfo["bio"],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: [
                FollowTitleComponent(100, "关注者", userInfo['id']),
                SizedBox(width: 10),
                FollowTitleComponent(100, "关注中", userInfo['id']),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.adjust, color: Colors.blue),
            title: Text("动态"),
            trailing: Chip(label: Text(userInfo["boilCount"].toString())),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BoilListPage("动态", "/boils/list/user/${userInfo['id']}"),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_outline_rounded, color: Colors.blue),
            title: Text("喜欢过的"),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoilListPage(
                      "喜欢过的", "/boils/list/user/${userInfo['id']}/like"),
                ),
              );
            },
            trailing: Chip(label: Text(userInfo["likeBoilCount"].toString())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article_outlined, color: Colors.blue),
            title: Text("评论过的"),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BoilListPage(
                        "评论过的", "/boils/list/user/${userInfo['id']}/comment")),
              );
            },
            trailing:
                Chip(label: Text(userInfo["commentBoilCount"].toString())),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class FollowTitleComponent extends StatelessWidget {
  int count;
  String title;
  int uid;
  FollowTitleComponent(this.count, this.title, this.uid);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Text("${count}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      onTap: () {
        String pageTitle = title + "(${count})";
        String api;
        if (title == "关注者") {
          api = "关注着api";
        } else {
          api = "关注中API";
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FollowUserListPage(pageTitle, api)));
      },
    );
  }
}
