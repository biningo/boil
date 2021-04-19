import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BoilListPage extends StatefulWidget {
  String title;
  String api;
  BoilListPage(this.title, this.api, {Key key}) : super(key: key);

  @override
  _BoilListPageState createState() => _BoilListPageState(this.api);
}

class _BoilListPageState extends State<BoilListPage> {
  String api;
  List boilList = [];
  _BoilListPageState(this.api);

  @override
  void initState() {
    super.initState();
    InitBoilVoList();
  }

  void InitBoilVoList() async {
    Response resp = await dio.get(api);
    setState(() {
      this.boilList = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  BoilItem(boilList[index], InitBoilVoList),
            ),
          ),
        ),
      ),
    );
  }
}
