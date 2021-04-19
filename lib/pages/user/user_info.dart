import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info_component.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  Map boilVo;
  UserInfoPage(this.boilVo, {Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map userStatus = {"msgCount": 0, "userBoilCount": 0, "likeBoilCount": 0};
  bool isFollow = false;
  @override
  void initState() {
    print("userinfo....");
    super.initState();
    InitUserStatus();
  }

  void InitUserStatus() async {
    Response resp = await dio.get("/user/status/${widget.boilVo['userId']}");
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
        body: Column(children: [
          UserInfoComponent(widget.boilVo, this.userStatus, InitUserStatus),
          // widget.userMap['isFollow']
          this.isFollow
              ? RaisedButton.icon(
                  onPressed: () {
                    setState(() {
                      isFollow = !isFollow;
                    });
                  },
                  icon: Icon(Icons.face),
                  color: Colors.green[100],
                  label: Text("取消关注"))
              : RaisedButton.icon(
                  onPressed: () {
                    setState(() {
                      isFollow = !isFollow;
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("关注他"))
        ]));
  }
}
