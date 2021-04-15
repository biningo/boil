import 'package:boil/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class TagDetailPage extends StatelessWidget {
  const TagDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("标签# " + args["title"]),
      ),
      body: Container(
        color: Colors.amber[50],
        child: RefreshIndicator(
          onRefresh: () async {
            return Future.value(true);
          },
          child: ListView.builder(
            itemCount: args["boilList"].length,
            itemBuilder: (context, index) {
              return InkWell(
                child: BoilItem(args["boilList"][index]),
                onTap: () {
                  Navigator.pushNamed(context, "/boil/detail");
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class TagsPage extends StatefulWidget {
  TagsPage({Key key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  List tags = [];

  @override
  void initState() {
    super.initState();
    InitTagList();
  }

  void InitTagList() async {
    Response resp = await dio.get("/tag/list");
    setState(() {
      tags = resp.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tagChips = this
        .tags
        .map(
          (val) => RawChip(
            avatar: Icon(Icons.tag),
            label: Text(
              val['title'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20.0),
            ),
            elevation: 10,
            onPressed: () async {
              Response resp = await dio.get("/boil/list/tag/${val['id']}");
              List tagBoilList = resp.data["data"];
              Navigator.pushNamed(context, "/tagDetail", arguments: {
                "title": val["title"],
                "id": val["id"],
                "boilList": tagBoilList
              });
            },
            pressElevation: 20,
          ),
        )
        .toList();
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 2 //宽高比为1时，子widget
            ),
        children: tagChips,
      ),
    );
  }
}
