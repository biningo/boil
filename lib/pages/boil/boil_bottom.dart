import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class LikeBoil extends StatefulWidget {
  String title = "未知";
  IconData iconData = Icons.star;
  Map boilVo;
  LikeBoil({Key key, this.title, this.iconData, this.boilVo}) : super(key: key);

  @override
  _LikeBoilState createState() =>
      _LikeBoilState(this.boilVo, this.title, this.iconData);
}

class _LikeBoilState extends State<LikeBoil> {
  String title;
  IconData iconData;
  Map boilVo;
  bool flag = false;

  _LikeBoilState(this.boilVo, this.title, this.iconData);
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
                  color: this.flag ? Colors.green : Colors.grey[400]),
              Text(this.title),
            ],
          ),
        ),
        onTap: () {
          if (this.title == "评论") {
            Navigator.pushNamed(context, "/boil/detail", arguments: boilVo);
          } else if (this.title == "喜欢") {
            setState(() {
              this.flag = !this.flag;
            });
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("敬请期待"),
                    ));
          }
        },
      ),
    );
  }
}

class CommentBoil extends StatefulWidget {
  int boilId;
  CommentBoil(this.boilId, {Key key}) : super(key: key);

  @override
  _CommentBoilState createState() => _CommentBoilState(this.boilId);
}

class _CommentBoilState extends State<CommentBoil> {
  int boilId;
  _CommentBoilState(this.boilId);
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
              Icon(Icons.app_registration, color: Colors.grey[400]),
              Text("评论"),
            ],
          ),
        ),
        onTap: () {
          if (!GlobalState["isLogin"]) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/user", (route) => route == null);
            return;
          }
          Navigator.pushNamed(context, "/comment/edit", arguments: boilId);
        },
      ),
    );
  }
}
