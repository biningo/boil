import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_bottom.dart';
import 'package:boil/pages/boil/boil_bottom_like.dart';
import 'package:boil/pages/boil/boil_detail.dart';
import 'package:boil/pages/boil/boil_list.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BoilItem extends StatelessWidget {
  Map boilVo;
  final Function initBoil;
  BoilItem(this.boilVo, this.initBoil);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () async {
        List<Widget> options = [
          SimpleDialogOption(
            onPressed: () {
              // 返回id
              Navigator.pop(context, 2);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text("回复",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
          )
        ];
        if (GlobalState["isLogin"] == true &&
            GlobalState["userInfo"]["id"] == boilVo["userId"]) {
          options.add(SimpleDialogOption(
            onPressed: () {
              // 返回id
              Navigator.pop(context, 1);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
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
          await dio.delete("/boil/${boilVo['id']}");
          initBoil();
        } else if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoilDetailPage(boilVo),
            ),
          );
        }
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoilDetailPage(boilVo),
          ),
        );
      },
      child: Container(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoilListPage(tagBoilList),
                          ),
                        );
                      },
                      borderSide: new BorderSide(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  BoilLikeBottom(boilVo['id']),
                  BoilBottom(
                    title: "评论(${boilVo['commentCount']})",
                    iconData: Icons.app_registration,
                    boilVo: boilVo,
                  ),
                  BoilBottom(title: "转发", iconData: Icons.adjust_sharp),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
