import 'package:boil/pages/boil/boil_detail.dart';
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
      color: Colors.amber[50],
      child: RefreshIndicator(
        onRefresh: () async {
          InitBoil();
          return Future.value(true);
        },
        child: ListView.builder(
          itemCount: this.boilList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: BoilItem(this.boilList[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoilDetailPage(this.boilList[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
