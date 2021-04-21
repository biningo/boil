import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_item.dart';
import 'package:boil/pages/empty.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  FollowPage({Key key}) : super(key: key);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  List boilList = [];
  List recommendUserList = [];
  @override
  void initState() {
    super.initState();
    InitBoilList();
    InitRecommendUserList();
  }

  void InitBoilList() async {
    Response resp = await dio.get("/boils/list/following");
    setState(() {
      this.boilList = resp.data["data"];
    });
  }

  void InitRecommendUserList() async {
    Response resp = await dio.get("/user/list/recommend");
    setState(() {
      this.recommendUserList = resp.data["data"];
    });
  }

  Widget getRecomendUserWidget() {
    return Column(
      children: recommendUserList
          .map((userInfo) => Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://blog.icepan.cloud/${userInfo['avatarId']}.jpg"),
                    radius: 35,
                  ),
                  RawChip(
                    avatar: Icon(userInfo['isFollow'] ? Icons.face : Icons.add,
                        color:
                            userInfo['isFollow'] ? Colors.white : Colors.black),
                    label: Text(
                      userInfo['isFollow'] ? "关注中" : "加关注",
                      style: TextStyle(
                          color: userInfo['isFollow']
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: userInfo['isFollow']
                        ? Colors.lightBlue[300]
                        : Colors.grey[300],
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoPage(userInfo['id']),
                        ),
                      );
                    },
                  ),
                ],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.recommendUserList.length != 0
            ? Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 2),
                        Text(
                          "推荐关注:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        getRecomendUserWidget(),
                        SizedBox(width: 20)
                      ],
                    )
                  ],
                ),
              )
            : SizedBox(),
        Container(
          child: boilList.length > 0
              ? RefreshIndicator(
                  onRefresh: () async {
                    InitBoilList();
                    return Future.value(true);
                  },
                  child: ListView(
                      shrinkWrap: true,
                      children: boilList
                          .map((boilVo) => BoilItem(boilVo, InitBoilList))
                          .toList()),
                )
              : EmptyPage(),
        )
      ],
    );
  }
}
