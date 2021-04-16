import 'package:boil/network.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class UserEditPage extends StatefulWidget {
  UserEditPage({Key key}) : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  String content;
  @override
  Widget build(BuildContext context) {
    setState(() {
      this.content = ModalRoute.of(context).settings.arguments;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "编辑个性签名",
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
              dio.post(
                "/user/update/bio/${GlobalState['userInfo']['id']}",
                data: {"bio": this.content},
              );
              GlobalState["userInfo"]["bio"] = this.content;
              Navigator.pop(context);
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
                controller: TextEditingController.fromValue(
                    TextEditingValue(text: this.content)),
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
