import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List msg = ["最近过得好吗?"];
  _HomePageState() {
    for (int i = 0; i < 20; i++) {
      this.msg.add("这是一个可爱的个性签名，这是一个可爱的个性签名这是一个可爱的个性签名");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[50],
      child: ListView.builder(
        itemCount: this.msg.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: BoilItem(content: this.msg[index]),
            onTap: () {
              Navigator.pushNamed(context, "/boil/detail");
            },
          );
        },
      ),
    );
  }
}

class BoilItem extends StatelessWidget {
  String content;
  BoilItem({Key key, this.content = ""}) : super(key: key);

  List<Widget> boilBottom = [
    LikeBoil(title: "点赞", iconData: Icons.star),
    LikeBoil(title: "点赞", iconData: Icons.star),
    LikeBoil(title: "点赞", iconData: Icons.star),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Card(
        child: Column(
          children: [
            InkWell(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
                title: Row(
                  children: [
                    Text(
                      "网名:浪迹天涯",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "十分钟前",
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              onTap: () {
                print("user");
              },
            ),
            Container(
              padding:
                  EdgeInsets.fromLTRB(10, 5, 10, 10), //left top right bottom
              alignment: Alignment.topLeft,
              child: Text(
                "内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容" +
                    "内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容" +
                    "内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容",
                style: TextStyle(fontSize: 15.0),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: OutlineButton.icon(
                    icon: Icon(Icons.tag, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    label: Text(
                      "幽默",
                      style: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/tagDetail",
                          arguments: "幽默");
                    },
                    borderSide: new BorderSide(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Row(
              children: boilBottom,
            )
          ],
        ),
      ),
    );
  }
}

class LikeBoil extends StatefulWidget {
  String title;
  IconData iconData;
  LikeBoil({Key key, this.title, this.iconData}) : super(key: key);

  @override
  _LikeBoilState createState() =>
      _LikeBoilState(title: this.title, iconData: this.iconData);
}

class _LikeBoilState extends State<LikeBoil> {
  String title;
  IconData iconData;
  bool flag = false;
  _LikeBoilState({this.title, this.iconData});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(this.iconData,
                  color:
                      this.flag == true ? Colors.green[300] : Colors.grey[300]),
              Text(this.title),
            ],
          ),
        ),
        onTap: () {
          setState(() {
            this.flag = !this.flag;
          });
        },
      ),
    );
  }
}
