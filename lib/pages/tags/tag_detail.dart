import 'package:boil/pages/boil/boil_detail.dart';
import 'package:boil/pages/boil/boil_item.dart';
import 'package:flutter/material.dart';

class TagDetailPage extends StatelessWidget {
  const TagDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("标签# " + args["title"]),
      ),
      body: Container(
        color: Colors.amber[50],
        child: RefreshIndicator(
          onRefresh: () async {
            return Future.value(true);
          },
          child: ListView.builder(
            itemCount: args["boilList"].length,
            itemBuilder: (context, index) {
              return InkWell(
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
    );
  }
}
