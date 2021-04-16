import 'package:boil/pages/user/user_is_login.dart';
import 'package:boil/pages/user/user_un_login.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLogin = GlobalState["isLogin"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ? IsLoginComponent() : UnLoginComponent();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
