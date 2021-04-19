import 'package:flutter/material.dart';

class BoilCommentBottom extends StatefulWidget {
  Map boilVo;
  Function initCommentList;
  BoilCommentBottom(this.boilVo, this.initCommentList, {Key key})
      : super(key: key);

  @override
  _BoilCommentBottomState createState() => _BoilCommentBottomState();
}

class _BoilCommentBottomState extends State<BoilCommentBottom> {
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
              Text("评论(${widget.boilVo['commentCount']})"),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, "/comment/edit",
                  arguments: widget.boilVo['id'])
              .then((value) => widget.initCommentList());
        },
      ),
    );
  }
}
