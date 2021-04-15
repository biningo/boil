import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//最近的搜索 会根据用户最近的输入进行匹配StartWith匹配
const searchList = ["wangcai", "xiaoxianrou", "dachangtui", "nvfengsi"];

//如果用户没有输入 则显示此列表
const recentSuggest = ["最近好吗?", "996我去你妈的", "下雨天"];

class searchBarDelegate extends SearchDelegate<String> {
//重写右侧的图标
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        //将搜索内容置为空
        onPressed: () => query = "",
      )
    ];
  }

//重写返回图标
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        //关闭上下文，当前页面
        onPressed: () => close(context, null));
  }

  //重写搜索结果
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(title: Text(query)),
          Divider(),
          ListTile(title: Text(query)),
          Divider(),
          ListTile(title: Text(query)),
          Divider(),
          ListTile(title: Text(query)),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggest
        : searchList.where((input) => input.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: ListTile(
            title: Text(suggestionList[index]),
          ),
          onTap: () {
            this.query = suggestionList[index];
          },
        );
      },
    );
  }
}
