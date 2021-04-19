import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
          (tagVo) => RawChip(
            avatar: Icon(Icons.tag),
            label: Text(
              tagVo['title'] + "(${tagVo['boilCount']})",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15.0),
            ),
            elevation: 8,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoilListPage(
                      tagVo['title'], "/boils/list/tag/${tagVo['id']}"),
                ),
              );
            },
            pressElevation: 10,
          ),
        )
        .toList();
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
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
