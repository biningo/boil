import 'package:flutter/material.dart';

class BoilCommentBottom extends StatefulWidget {
  Map boilVo;
  Function initCommentList;
  BoilCommentBottom(this.boilVo, this.initCommentList, {Key key})
      : super(key: key);

  @override
  _BoilCommentBottomState createState() =>
      _BoilCommentBottomState(this.boilVo, this.initCommentList);
}

class _BoilCommentBottomState extends State<BoilCommentBottom> {
  Map boilVo;
  Function initCommentList;
  _BoilCommentBottomState(this.boilVo, this.initCommentList);

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
              Icon(Icons.app_registration, color: Colors.grey[400]),
              Text("评论(${boilVo['commentCount']})"),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, "/comment/edit",
                  arguments: this.boilVo['id'])
              .then((value) => initCommentList());
        },
      ),
    );
  }
}
