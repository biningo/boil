import 'package:flutter/material.dart';

class UserMessagePage extends StatefulWidget {
  UserMessagePage({Key key}) : super(key: key);

  @override
  _UserMessagePageState createState() => _UserMessagePageState();
}

class _UserMessagePageState extends State<UserMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
      ),
      body: Text("用户消息"),
    );
  }
}
