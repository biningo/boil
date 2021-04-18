import 'dart:convert';

import 'package:boil/network.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            Navigator.pop(context, this.content);
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
              await dio.post(
                "/user/update/bio/${GlobalState['userInfo']['id']}",
                data: {"bio": this.content},
              );
              GlobalState["userInfo"]["bio"] = this.content;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("userInfo", jsonEncode(GlobalState['userInfo']));
              Navigator.pop(context, this.content);
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: true,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: this.content)),
            style: TextStyle(fontSize: 20.0),
            maxLines: 2,
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
