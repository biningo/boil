import 'package:boil/pages/boil/boil_item.dart';
import 'package:boil/pages/empty.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../network.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List boilList = [];
  @override
  void initState() {
    super.initState();
    InitBoilList();
  }

  void InitBoilList() async {
    Response resp = await dio.get("/boils/list");
    setState(() {
      this.boilList = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return boilList.length > 0
        ? Container(
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
          )
        : EmptyPage();
  }
}
