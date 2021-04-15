import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../network.dart';
import 'home.dart';

class BoilDetailPage extends StatefulWidget {
  BoilDetailPage({Key key}) : super(key: key);

  @override
  _BoilDetailPageState createState() => _BoilDetailPageState();
}

class _BoilDetailPageState extends State<BoilDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map boilVo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("沸点详情"),
      ),
      body: Container(
        child: Column(
          children: [
            InkWell(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://blog.icepan.cloud/${boilVo["userAvatarId"]}.jpg"),
                  radius: 30,
                ),
                title: Row(
                  children: [
                    Text(
                      "网名:${boilVo['username']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Text(
                      boilVo["createTime"],
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  boilVo["userBio"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(title: Text(boilVo["username"])));
              },
            ),
            Container(
              padding:
                  EdgeInsets.fromLTRB(10, 5, 10, 10), //left top right bottom
              alignment: Alignment.topLeft,
              child: Text(
                boilVo["content"],
                style: TextStyle(fontSize: 15.0),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: OutlineButton.icon(
                    icon: Icon(Icons.tag, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    label: Text(
                      boilVo["tagTitle"],
                      style: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    onPressed: () async {
                      Response resp =
                          await dio.get("/boil/list/tag/${boilVo['tagId']}");
                      List tagBoilList = resp.data["data"];
                      Navigator.pushNamed(context, "/tagDetail", arguments: {
                        "title": boilVo["tagTitle"],
                        "id": boilVo["tagId"],
                        "boilList": tagBoilList
                      });
                    },
                    borderSide: new BorderSide(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Row(
              children: boilBottom,
            )
          ],
        ),
      ),
    );
  }
}

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
                dio.post("/boil/publish", data: {
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

class BoilListPage extends StatefulWidget {
  BoilListPage({Key key}) : super(key: key);

  @override
  _BoilListPageState createState() => _BoilListPageState();
}

class _BoilListPageState extends State<BoilListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("沸点列表"),
      ),
      body: Text("boil list"),
    );
  }
}
