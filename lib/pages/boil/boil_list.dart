import 'package:boil/pages/boil/boil_item.dart';
import 'package:flutter/material.dart';

class BoilListPage extends StatefulWidget {
  List boilList;
  BoilListPage(this.boilList, {Key key}) : super(key: key);

  @override
  _BoilListPageState createState() => _BoilListPageState(this.boilList);
}

class _BoilListPageState extends State<BoilListPage> {
  List boilList;
  _BoilListPageState(this.boilList);

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
              itemBuilder: (context, index) => BoilItem(boilList[index], () {}),
            ),
          ),
        ),
      ),
    );
  }
}
