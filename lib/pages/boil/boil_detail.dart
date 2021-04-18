import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_bottom.dart';
import 'package:boil/pages/boil/boil_bottom_comment.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BoilDetailPage extends StatefulWidget {
  Map boilVo;
  BoilDetailPage(this.boilVo, {Key key}) : super(key: key);
  @override
  _BoilDetailPageState createState() => _BoilDetailPageState(this.boilVo);
}

class _BoilDetailPageState extends State<BoilDetailPage> {
  List comments = [];
  Map boilVo;
  _BoilDetailPageState(this.boilVo);

  @override
  void initState() {
    super.initState();
    InitCommentList();
  }

  void InitCommentList() async {
    Response resp = await dio.get("/comment/list/${boilVo['id']}");
    setState(() {
      this.comments = resp.data["data"];
      boilVo['commentCount'] = this.comments.length;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                      {
                        "userId": boilVo["userId"],
                        "userAvatarId": boilVo["userAvatarId"],
                        "userBio": boilVo["userBio"]
                      },
                    ),
                  ),
                );
              },
            ),
            Container(
              padding:
                  EdgeInsets.fromLTRB(10, 5, 10, 10), //left top right bottom
              alignment: Alignment.topLeft,
              child: Text(
                boilVo["content"],
                style: TextStyle(fontSize: 20.0),
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
              children: [
                BoilBottom(title: "喜欢", iconData: Icons.star_outline_rounded),
                BoilCommentBottom(boilVo, InitCommentList),
                BoilBottom(title: "转发", iconData: Icons.adjust_sharp),
              ],
            ),
            Divider(),
            Expanded(
              child: RefreshIndicator(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: this
                      .comments
                      .map(
                        (commentVo) => Container(
                          child: Column(
                            children: [
                              Divider(),
                              InkWell(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        "https://blog.icepan.cloud/${commentVo["userAvatarId"]}.jpg"),
                                    radius: 20,
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        "网名:${commentVo['username']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        commentVo["createTime"],
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    commentVo["userBio"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserInfoPage(
                                        {
                                          "userId": commentVo["userId"],
                                          "userAvatarId":
                                              commentVo["userAvatarId"],
                                          "userBio": commentVo["userBio"]
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              InkWell(
                                onLongPress: () async {
                                  List<Widget> options = [];
                                  if (GlobalState["isLogin"] == true &&
                                      GlobalState["userInfo"]["id"] ==
                                          commentVo["userId"]) {
                                    options.add(SimpleDialogOption(
                                      onPressed: () {
                                        // 返回id
                                        Navigator.pop(context, 1);
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 6),
                                        child: Text("删除",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            )),
                                      ),
                                    ));
                                  }
                                  int i = await showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          children: options,
                                        );
                                      });
                                  if (i == 1) {
                                    await dio
                                        .delete("/comment/${commentVo['id']}");
                                    InitCommentList();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      40, 0, 0, 0), //left top right bottom
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    commentVo["content"],
                                    style: TextStyle(fontSize: 15.0),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                onRefresh: () async {
                  InitCommentList();
                  return Future.value(true);
                },
              ),
            ),
            SizedBox(
                width: 500,
                height: 60,
                child: OutlineButton(
                  child: Wrap(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      Text("写评论",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/comment/edit",
                            arguments: boilVo['id'])
                        .then((value) {
                      InitCommentList();
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
