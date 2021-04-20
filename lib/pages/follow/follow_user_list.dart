import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FollowUserListPage extends StatefulWidget {
  String title;
  String api;
  FollowUserListPage(this.title, this.api, {Key key}) : super(key: key);

  @override
  _FollowUserListPageState createState() => _FollowUserListPageState();
}

class _FollowUserListPageState extends State<FollowUserListPage> {
  List userList = [
    {
      "avatarId": 0,
      "username": "dsda",
      "bio": "哈哈哈哈",
      "isFollow": true,
    },
    {
      "avatarId": 0,
      "username": "dsda",
      "bio": "哈哈哈哈",
      "isFollow": true,
    }
  ];

  @override
  void initState() {
    super.initState();
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
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: ListTile(
                trailing: RawChip(
                  avatar: Icon(
                      userList[index]['isFollow'] ? Icons.face : Icons.add,
                      color: Colors.black),
                  label: Text(
                    userList[index]['isFollow'] ? "关注中" : "加关注",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: userList[index]['isFollow']
                      ? Colors.blue[300]
                      : Colors.grey[300],
                  onPressed: () {
                    if (GlobalState['isLogin'] == false) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/user", (route) => route == null);
                      return;
                    }
                    setState(() {
                      userList[index]['isFollow'] =
                          !userList[index]['isFollow'];
                    });
                  },
                  elevation: 2,
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
                      "网名:${userList[index]['username']}",
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => UserInfoPage(),
                //   ),
                // );
              },
            );
          }),
    );
  }
}
