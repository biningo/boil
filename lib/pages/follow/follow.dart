import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FollowPage extends StatefulWidget {
  FollowPage({Key key}) : super(key: key);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  List boilList = [];
  @override
  void initState() {
    super.initState();
    InitBoilList();
  }

  void InitBoilList() async {
    Response resp = await dio.get("/boils/list/following");
    setState(() {
      this.boilList = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          InitBoilList();
          return Future.value(true);
        },
        child: ListView(
            children: boilList
                .map((boilVo) => BoilItem(boilVo, InitBoilList))
                .toList()),
      ),
    );
  }
}
