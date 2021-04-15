import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../network.dart';

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
                Navigator.pushNamed(context, "/boil/detail",
                    arguments: this.boilList[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

List<Widget> boilBottom = [
  LikeBoil(title: "点赞", iconData: Icons.star),
  LikeBoil(title: "评论", iconData: Icons.app_registration),
  LikeBoil(title: "转发", iconData: Icons.adjust_sharp),
];

class BoilItem extends StatelessWidget {
  Map boilVo;
  BoilItem(this.boilVo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Card(
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

class LikeBoil extends StatefulWidget {
  String title;
  IconData iconData;
  LikeBoil({Key key, this.title, this.iconData}) : super(key: key);

  @override
  _LikeBoilState createState() =>
      _LikeBoilState(title: this.title, iconData: this.iconData);
}

class _LikeBoilState extends State<LikeBoil> {
  String title;
  IconData iconData;
  bool flag = false;
  _LikeBoilState({this.title, this.iconData});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(this.iconData,
                  color:
                      this.flag == true ? Colors.green[300] : Colors.grey[300]),
              Text(this.title),
            ],
          ),
        ),
        onTap: () {
          setState(() {
            this.flag = !this.flag;
          });
        },
      ),
    );
  }
}
