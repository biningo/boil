import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_list.dart';
import 'package:boil/pages/empty.dart';
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
    return Container(
      child: tags.length > 0
          ? ListView.builder(
              itemCount: this.tags.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      child: ListTile(
                        leading:
                            Icon(Icons.keyboard_arrow_right_rounded, size: 20),
                        title: Text(
                          "${tags[index]['title']}(${tags[index]['boilCount']})",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoilListPage(
                                tags[index]['title'],
                                "/boils/list/tag/${tags[index]['id']}"),
                          ),
                        );
                      },
                    ),
                    Divider()
                  ],
                );
              },
            )
          : EmptyPage(),
    );
  }
}
