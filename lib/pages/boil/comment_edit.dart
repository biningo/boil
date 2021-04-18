import 'package:boil/network.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class CommentEditPage extends StatefulWidget {
  CommentEditPage({Key key}) : super(key: key);

  @override
  _CommentEditPageState createState() => _CommentEditPageState();
}

class _CommentEditPageState extends State<CommentEditPage> {
  String content;
  int boilId;
  @override
  Widget build(BuildContext context) {
    setState(() {
      this.boilId = ModalRoute.of(context).settings.arguments;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "评论",
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
              "确定",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
              ),
            ),
            onPressed: () async {
              if (!GlobalState["isLogin"]) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/user", (route) => route == null);
                return;
              }
              if (this.content == null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(title: Text("内容不能为空")));
              } else {
                await dio.post("/comment/publish/${this.boilId}",
                    data: {"content": this.content});
                Navigator.pop(context);
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
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                maxLines: 10,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  this.content = val;
                },
              ),
            ],
          )),
    );
  }
}
