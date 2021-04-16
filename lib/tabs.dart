import 'dart:convert';

import 'package:boil/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home/home.dart';
import 'pages/search/search.dart';
import 'pages/tags/tags.dart';
import 'pages/user/user.dart';

class Tabs extends StatefulWidget {
  int currentIndex;
  Tabs({Key key, this.currentIndex = 0}) : super(key: key);
  @override
  _TabsState createState() => _TabsState(currentIndex: this.currentIndex);
}

class _TabsState extends State<Tabs> {
  int currentIndex;
  _TabsState({this.currentIndex = 0});
  List<Widget> pages = [HomePage(), TagsPage(), UserPage()];
  List<BottomNavigationBarItem> bottomItems = [
    BottomBarItem("沸点", Icons.adjust_sharp),
    BottomBarItem("标签", Icons.tag),
    BottomBarItem("我的", Icons.account_circle_outlined),
  ];

  @override
  void initState() {
    print("tabs------------------");
    super.initState();
    InitGlobalState();
  }

  void InitGlobalState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalState["isLogin"] =
        prefs.getBool("isLogin") != null ? prefs.getBool("isLogin") : false;
    if (GlobalState["isLogin"]) {
      GlobalState["userInfo"] = jsonDecode(prefs.getString("userInfo"));
      GlobalState["token"] = prefs.getString("token");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, "/write");
          },
        ),
        appBar: AppBar(
          title: Text("Boil"),
          centerTitle: true, //标题居中显示
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: searchBarDelegate());
              },
            ),
            IconButton(
                icon: Icon(Icons.notifications_active_outlined),
                onPressed: () {
                  if (!GlobalState["isLogin"]) {
                    Navigator.pushNamed(context, "/user");
                    return;
                  }
                  Navigator.pushNamed(context, "/user/message");
                })
          ],
        ),
        body: this.pages[this.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              this.currentIndex = index;
            });
          },
          currentIndex: this.currentIndex,
          fixedColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: bottomItems,
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("--------tab down------");
    super.dispose();
  }
}

//BottomNavigationBarItem
BottomNavigationBarItem BottomBarItem(String title, IconData iconData) {
  return BottomNavigationBarItem(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w600),
    ),
    icon: Icon(iconData),
  );
}
