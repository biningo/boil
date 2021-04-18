import 'package:boil/pages/boil/boil_detail.dart';
import 'package:flutter/material.dart';

class BoilBottom extends StatelessWidget {
  String title;
  IconData iconData;
  Map boilVo;
  bool flag = false;

  BoilBottom({this.boilVo, this.title, this.iconData});
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
                  color: this.flag ? Colors.green : Colors.grey[400]),
              Text(this.title),
            ],
          ),
        ),
        onTap: () {
          if (this.title == "评论") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoilDetailPage(boilVo),
              ),
            );
          } else if (this.title == "喜欢") {
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("敬请期待"),
                    ));
          }
        },
      ),
    );
  }
}
