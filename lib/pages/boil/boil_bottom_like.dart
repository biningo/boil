import 'package:boil/network.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class BoilLikeBottom extends StatefulWidget {
  Map boilVo;
  BoilLikeBottom(this.boilVo, {Key key}) : super(key: key);

  @override
  _BoilLikeBottomState createState() => _BoilLikeBottomState();
}

class _BoilLikeBottomState extends State<BoilLikeBottom> {
  @override
  void initState() {
    super.initState();
  }

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
              Icon(
                  widget.boilVo['isLike']
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color:
                      widget.boilVo['isLike'] ? Colors.red : Colors.grey[400]),
              Text(
                "喜欢(${widget.boilVo['likeCount']})",
                style: TextStyle(
                    color: widget.boilVo['isLike'] ? Colors.red : Colors.black),
              ),
            ],
          ),
        ),
        onTap: () async {
          if (!GlobalState['isLogin']) {
            Navigator.popAndPushNamed(context, "/user");
            return;
          }
          setState(() {
            widget.boilVo['isLike'] = !widget.boilVo['isLike'];
          });
          if (widget.boilVo['isLike']) {
            await dio.get(
                "/boils/user/${GlobalState['userInfo']['id']}/like/${widget.boilVo['id']}");
            setState(() {
              widget.boilVo['likeCount']++;
            });
          } else {
            await dio.get(
                "/boils/user/${GlobalState['userInfo']['id']}/unlike/${widget.boilVo['id']}");
            setState(() {
              widget.boilVo['likeCount']--;
            });
          }
        },
      ),
    );
  }
}
