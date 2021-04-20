import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_bottom.dart';
import 'package:boil/pages/boil/boil_detail.dart';
import 'package:boil/pages/boil/boil_list.dart';
import 'package:boil/pages/boil/boil_user_component.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class BoilItem extends StatefulWidget {
  Map boilVo;
  final Function initBoilList;
  BoilItem(this.boilVo, this.initBoilList, {Key key}) : super(key: key);

  @override
  _BoilItemState createState() => _BoilItemState();
}

class _BoilItemState extends State<BoilItem> {
  _BoilItemState();

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
            GlobalState["userInfo"]["id"] == widget.boilVo["userId"]) {
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
          await dio.delete("/boils/${widget.boilVo['id']}");
          widget.initBoilList();
        } else if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoilDetailPage(widget.boilVo),
            ),
          ).then((value) => widget.initBoilList());
        }
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoilDetailPage(widget.boilVo),
          ),
        ).then((value) => widget.initBoilList());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
          child: Column(
            children: [
              BoilUserComponent(widget.boilVo),
              Container(
                padding:
                    EdgeInsets.fromLTRB(10, 5, 10, 10), //left top right bottom
                alignment: Alignment.topLeft,
                child: Text(
                  widget.boilVo["content"],
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
                        widget.boilVo["tagTitle"],
                        style: TextStyle(
                            color: Colors.blue[300],
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoilListPage(
                                widget.boilVo['tagTitle'],
                                "/boils/list/tag/${widget.boilVo['tagId']}"),
                          ),
                        ).then((value) => widget.initBoilList());
                      },
                      borderSide: new BorderSide(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  BoilBottom(
                    Text(
                      "喜欢(${widget.boilVo['likeCount']})",
                      style: TextStyle(
                          color: widget.boilVo['isLike']
                              ? Colors.red
                              : Colors.black),
                    ),
                    Icon(
                        widget.boilVo['isLike']
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: widget.boilVo['isLike']
                            ? Colors.red
                            : Colors.grey[400]),
                    boilVo: widget.boilVo,
                    handler: () async {
                      if (!GlobalState['isLogin']) {
                        Navigator.popAndPushNamed(context, "/user");
                        return;
                      }
                      setState(() {
                        widget.boilVo['isLike'] = !widget.boilVo['isLike'];
                      });
                      if (widget.boilVo['isLike']) {
                        await dio.get(
                            "/boils/user/${GlobalState['userInfo']['id']}/like/${widget.boilVo['id']}");
                        setState(() {
                          widget.boilVo['likeCount']++;
                        });
                      } else {
                        await dio.get(
                            "/boils/user/${GlobalState['userInfo']['id']}/unlike/${widget.boilVo['id']}");
                        setState(() {
                          widget.boilVo['likeCount']--;
                        });
                      }
                    },
                  ),
                  BoilBottom(
                    Text("评论(${widget.boilVo['commentCount']})"),
                    Icon(Icons.app_registration, color: Colors.grey[400]),
                    boilVo: widget.boilVo,
                    handler: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoilDetailPage(widget.boilVo),
                        ),
                      ).then((value) => widget.initBoilList());
                    },
                  ),
                  BoilBottom(
                    Text("转发"),
                    Icon(Icons.adjust_sharp, color: Colors.grey[400]),
                    handler: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("敬请期待"),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
