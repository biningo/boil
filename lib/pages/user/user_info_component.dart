import 'package:boil/pages/boil/boil_list.dart';
import 'package:flutter/material.dart';

class UserInfoComponent extends StatelessWidget {
  Map userStatus;
  Map boilVo;
  Function initUserStatus;
  UserInfoComponent(this.boilVo, this.userStatus, this.initUserStatus,
      {Key key})
      : super(key: key);

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
                        "https://blog.icepan.cloud/${boilVo['userAvatarId']}.jpg"),
                    radius: 60,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(boilVo["userBio"],
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: [
                FollowTextComponent(userStatus["followers"], "关注者"),
                SizedBox(width: 10),
                FollowTextComponent(userStatus["following"], "关注中"),
              ],
            ),
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
                  builder: (context) => BoilListPage(
                      "动态", "/boils/list/user/${boilVo['userId']}"),
                ),
              ).then((value) => initUserStatus());
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
                      "喜欢过的", "/boils/list/user/${boilVo['userId']}/like"),
                ),
              ).then((value) => initUserStatus());
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
                    builder: (context) => BoilListPage("评论过的",
                        "/boils/list/user/${boilVo['userId']}/comment")),
              ).then((value) => initUserStatus());
            },
            trailing: Chip(label: Text(userStatus["commentCount"].toString())),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class FollowTextComponent extends StatelessWidget {
  int count;
  String title;
  FollowTextComponent(this.count, this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Text("${this.count}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            this.title,
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      onTap: () async {
        List<Widget> userList = [];
        for (int i = 0; i < 20; i++) {
          userList.add(
            SimpleDialogOption(
              onPressed: () {
                // 返回id
                Navigator.pop(context, 1);
              },
              child: ListTile(
                trailing: RawChip(
                  avatar: Icon(Icons.add, color: Colors.white),
                  label: Text("关注", style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                  onPressed: () {},
                  elevation: 5,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      NetworkImage("https://blog.icepan.cloud/0.jpg"),
                ),
                title: Row(
                  children: [
                    Text(
                      "网名:dadad",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  "我轻轻的走,我轻轻的来",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          );
        }
        int i = await showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(this.title + "(${this.count})"),
                children: userList,
              );
            });
      },
    );
  }
}
