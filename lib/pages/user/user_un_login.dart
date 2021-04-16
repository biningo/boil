import 'package:boil/pages/user/user_login.dart';
import 'package:flutter/material.dart';

class UnLoginComponent extends StatefulWidget {
  UnLoginComponent({Key key}) : super(key: key);

  @override
  _UnLoginComponentState createState() => _UnLoginComponentState();
}

class _UnLoginComponentState extends State<UnLoginComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 100),
          Center(
            child: Container(
              width: 80,
              height: 80,
              child: new CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Text(
                  "可爱的头像",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            child: Card(
              child: LoginComponent(),
            ),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          )
        ],
      ),
    );
  }
}
