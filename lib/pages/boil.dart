import 'package:flutter/material.dart';

class BoilDetailPage extends StatefulWidget {
  BoilDetailPage({Key key}) : super(key: key);

  @override
  _BoilPageState createState() => _BoilPageState();
}

class _BoilPageState extends State<BoilDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("沸点详情"),
      ),
      body: Container(
        child: Text("Boil"),
      ),
    );
  }
}

class WriteBoilPage extends StatefulWidget {
  WriteBoilPage({Key key}) : super(key: key);

  @override
  _WriteBoilPageState createState() => _WriteBoilPageState();
}

class _WriteBoilPageState extends State<WriteBoilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "发布沸点",
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
              "发布",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
              print("发布");
            },
          )
        ],
      ),
      body: Container(
        child: Text("Write"),
      ),
    );
  }
}

class BoilListPage extends StatefulWidget {
  BoilListPage({Key key}) : super(key: key);

  @override
  _BoilListPageState createState() => _BoilListPageState();
}

class _BoilListPageState extends State<BoilListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("沸点列表"),
      ),
      body: Text("boil list"),
    );
  }
}
