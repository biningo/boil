import 'package:boil/network.dart';
import 'package:boil/pages/boil/boil_detail.dart';
import 'package:boil/pages/boil/boil_item.dart';
import 'package:boil/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BoilListPage extends StatefulWidget {
  BoilListPage({Key key}) : super(key: key);

  @override
  _BoilListPageState createState() => _BoilListPageState();
}

class _BoilListPageState extends State<BoilListPage> {
  Map args;

  void InitBoil() async {
    if (args["boilList"].length > 0) {
      Response resp =
          await dio.get("/boil/list/user/${args['boilList'][0]['userId']}");
      setState(() {
        args["boilList"] = resp.data["data"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = ModalRoute.of(context).settings.arguments;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("沸点列表"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          InitBoil();
          return Future.value(true);
        },
        child: Container(
          color: Colors.amber[50],
          child: RefreshIndicator(
            onRefresh: () async {
              return Future.value(true);
            },
            child: ListView.builder(
              itemCount: args["boilList"].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: () async {
                    List<Widget> options = [
                      SimpleDialogOption(
                        onPressed: () {
                          // 返回id
                          Navigator.pop(context, 2);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text("回复",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ];
                    if (GlobalState["isLogin"] == true &&
                        GlobalState["userInfo"]["id"] ==
                            args["boilList"][index]["userId"]) {
                      options.add(SimpleDialogOption(
                        onPressed: () {
                          // 返回id
                          Navigator.pop(context, 1);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text("删除",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              )),
                        ),
                      ));
                    }
                    int i = await showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            children: options,
                          );
                        });
                    if (i == 1) {
                      Response resp = await dio
                          .delete("/boil/${args['boilList'][index]['id']}");
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(title: Text(resp.data["msg"])));
                    }
                  },
                  child: BoilItem(args["boilList"][index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BoilDetailPage(args["boilList"][index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
