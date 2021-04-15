import 'package:boil/pages/boil.dart';
import 'package:boil/pages/tags.dart';
import 'package:boil/pages/user.dart';
import 'package:boil/tabs.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  "/boil/detail": (context) => BoilDetailPage(),
  "/boil/list": (context) => BoilListPage(),
  "/tagDetail": (context) => TagDetailPage(),
  "/write": (context) => WriteBoilPage(),
  "/user": (context) => Tabs(currentIndex: 2),
  "/user/message": (context) => UserMessagePage()
};
