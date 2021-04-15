import 'package:flutter/material.dart';

class TagDetailPage extends StatelessWidget {
  TagDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("标签# " + args),
      ),
      body: Text("...."),
    );
  }
}

class TagsPage extends StatefulWidget {
  TagsPage({Key key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> arr = [
      RawChip(
        avatar: Icon(Icons.tag),
        label: Text(
          '工作',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, "/tagDetail", arguments: "工作");
        },
        pressElevation: 20,
      ),
      RawChip(
        avatar: Icon(Icons.tag),
        label: Text(
          '生活',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, "/tagDetail", arguments: "生活");
        },
        pressElevation: 20,
      ),
      RawChip(
        avatar: Icon(Icons.tag),
        label: Text(
          '美食',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, "/tagDetail", arguments: "美食");
        },
        pressElevation: 20,
      ),
      RawChip(
        avatar: Icon(Icons.tag),
        label: Text(
          '爱情',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, "/tagDetail", arguments: "爱情");
        },
        pressElevation: 20,
      ),
      RawChip(
        avatar: Icon(Icons.tag),
        label: Text(
          '旅游',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, "/tagDetail", arguments: "旅游");
        },
        pressElevation: 20,
      ),
      RawChip(
        avatar: Icon(Icons.tag),
        label: Text(
          '其他',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushNamed(context, "/tagDetail", arguments: "其它");
        },
        pressElevation: 20,
      )
    ];
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 2 //宽高比为1时，子widget
            ),
        children: arr,
      ),
    );
  }
}
