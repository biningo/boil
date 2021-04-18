import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BoilListUserPage extends StatefulWidget {
  String api;
  BoilListUserPage(this.api, {Key key}) : super(key: key);

  @override
  _BoilListUserPageState createState() => _BoilListUserPageState(this.api);
}

class _BoilListUserPageState extends State<BoilListUserPage> {
  List boilList = [];
  String api;

  _BoilListUserPageState(this.api);

  @override
  void initState() {
    super.initState();
    InitBoilList();
  }

  void InitBoilList() async {
    Response resp = await dio.get(this.api);
    setState(() {
      this.boilList = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("沸点列表"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.value(true);
        },
        child: Container(
          child: RefreshIndicator(
            onRefresh: () async {
              return Future.value(true);
            },
            child: ListView.builder(
              itemCount: boilList.length,
              itemBuilder: (context, index) =>
                  BoilItem(boilList[index], InitBoilList),
            ),
          ),
        ),
      ),
    );
  }
}
