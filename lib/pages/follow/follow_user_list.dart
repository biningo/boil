import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  String title;
  String api;
  UserListPage(this.title, this.api, {Key key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List userList = [];

  @override
  void initState() {
    super.initState();
    InitUserList();
  }

  void InitUserList() async {
    Response resp = await dio.get(widget.api);
    setState(() {
      userList = resp.data['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: userList == null ? 0 : userList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: ListTile(
                trailing: RawChip(
                  avatar: Icon(
                      userList[index]['isFollow'] ? Icons.face : Icons.add,
                      color: userList[index]['isFollow']
                          ? Colors.white
                          : Colors.black),
                  label: Text(
                    userList[index]['isFollow'] ? "关注中" : "加关注",
                    style: TextStyle(
                        color: userList[index]['isFollow']
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: userList[index]['isFollow']
                      ? Colors.lightBlue[300]
                      : Colors.grey[300],
                  onPressed: () async {
                    Map userInfo = userList[index];
                    if (GlobalState['isLogin'] == false) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/user", (route) => route == null);
                      return;
                    }
                    setState(() {
                      userInfo['isFollow'] = !userInfo['isFollow'];
                    });
                    if (userInfo['isFollow']) {
                      await dio.get("/user/follow/${userInfo['id']}");
                    } else {
                      await dio.get("/user/unfollow/${userInfo['id']}");
                    }
                  },
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://blog.icepan.cloud/${userList[index]["avatarId"]}.jpg"),
                  radius: 30,
                ),
                title: Row(
                  children: [
                    Text(
                      "${userList[index]['username']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Text(
                  userList[index]["bio"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(userList[index]['id']),
                  ),
                );
              },
            );
          }),
    );
  }
}
