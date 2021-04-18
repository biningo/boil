import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  Map commentVo;

  CommentItem(this.commentVo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      "userAvatarId": commentVo["userAvatarId"],
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
                  GlobalState["userInfo"]["id"] == commentVo["userId"]) {
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
                await dio.delete("/comment/${commentVo['id']}");
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0), //left top right bottom
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
    );
  }
}
