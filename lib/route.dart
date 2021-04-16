import 'package:boil/pages/boil/boil_detail.dart';
import 'package:boil/pages/boil/boil_list.dart';
import 'package:boil/pages/boil/comment_edit.dart';
import 'package:boil/pages/boil/write_boil.dart';
import 'package:boil/pages/tags/tag_detail.dart';
import 'package:boil/pages/user/user_edit.dart';
import 'package:boil/pages/user/user_message.dart';
import 'package:boil/tabs.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  "/tagDetail": (context) => TagDetailPage(),
  "/write": (context) => WriteBoilPage(),
  "/user": (context) => Tabs(currentIndex: 2),
  "/home": (context) => Tabs(currentIndex: 0),
  "/user/message": (context) => UserMessagePage(),
  "/boil/list": (context) => BoilListPage(),
  "/user/edit": (context) => UserEditPage(),
  "/comment/edit": (context) => CommentEditPage()
};
