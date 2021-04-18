import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:boil/network.dart';

class WriteBoilPage extends StatefulWidget {
  WriteBoilPage({Key key}) : super(key: key);

  @override
  _WriteBoilPageState createState() => _WriteBoilPageState();
}

class _WriteBoilPageState extends State<WriteBoilPage> {
  String content;
  int tagId = 0;
  String tagTitle = "选择标签";
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
    List<Widget> tagSelectList = this
        .tags
        .asMap()
        .entries
        .map((val) => SimpleDialogOption(
              onPressed: () {
                // 返回id
                Navigator.pop(context, val.key);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(val.value['title']),
              ),
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "发布沸点",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_return, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "发布",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
              ),
            ),
            onPressed: () async {
              bool isLogin = GlobalState["isLogin"];
              if (!isLogin) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/user", (route) => route == null);
              } else if (this.content == "" || this.tagId == 0) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(title: Text("信息不正确")));
              } else {
                await dio.post("/boil/publish", data: {
                  "content": this.content,
                  "tagId": this.tagId,
                  "userId": GlobalState["userInfo"]["id"]
                });
                Navigator.pushNamedAndRemoveUntil(
                    context, "/home", (route) => route == null);
              }
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: TextStyle(fontSize: 20.0),
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "此刻我想说....",
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  this.content = val;
                },
              ),
              RawChip(
                label: Text(this.tagTitle),
                avatar: Icon(Icons.arrow_right),
                backgroundColor: Colors.blue[100],
                onPressed: () async {
                  int i = await showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text('请选择标签'),
                          children: tagSelectList,
                        );
                      });

                  if (i != null) {
                    setState(() {
                      this.tagTitle = this.tags[i]["title"];
                      this.tagId = this.tags[i]["id"];
                    });
                  }
                },
              )
            ],
          )),
    );
  }
}
