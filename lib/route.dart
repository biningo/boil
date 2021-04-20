import 'package:boil/pages/boil/comment_edit.dart';
import 'package:boil/pages/boil/write_boil.dart';
import 'package:boil/pages/user/user_edit.dart';
import 'package:boil/pages/user/user_message.dart';
import 'package:boil/tabs.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  "/write": (context) => WriteBoilPage(),
  "/user": (context) => Tabs(currentIndex: 3),
  "/home": (context) => Tabs(currentIndex: 0),
  "/user/message": (context) => UserMessagePage(),
  "/user/edit": (context) => UserEditPage(),
  "/comment/edit": (context) => CommentEditPage()
};
