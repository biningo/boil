import 'package:boil/pages/boil/boil_item.dart';
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
    print("---------home--------");
    InitBoil();
  }

  void InitBoil() async {
    Response resp = await dio.get("/boil/all");
    setState(() {
      this.boilList = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          InitBoil();
          return Future.value(true);
        },
        child: ListView(
            children:
                boilList.map((boilVo) => BoilItem(boilVo, InitBoil)).toList()),
      ),
    );
  }
}