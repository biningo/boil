import 'package:boil/network.dart';
import 'package:boil/pages/user/user_info.dart';
import 'package:boil/utils.dart';
import 'package:flutter/material.dart';

class BoilUserComponent extends StatefulWidget {
  Map boilVo;
  BoilUserComponent(this.boilVo, {Key key}) : super(key: key);

  @override
  _BoilUserComponentState createState() => _BoilUserComponentState();
}

class _BoilUserComponentState extends State<BoilUserComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        trailing: RawChip(
          avatar: Icon(widget.boilVo['userIsFollow'] ? Icons.face : Icons.add,
              color:
                  widget.boilVo['userIsFollow'] ? Colors.white : Colors.black),
          label: Text(
            widget.boilVo['userIsFollow'] ? "关注中" : "加关注",
            style: TextStyle(
                color:
                    widget.boilVo['userIsFollow'] ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: widget.boilVo['userIsFollow']
              ? Colors.lightBlue[300]
              : Colors.grey[300],
          onPressed: () async {
            if (GlobalState['isLogin'] == false) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/user", (route) => route == null);
              return;
            }
            setState(() {
              widget.boilVo['userIsFollow'] = !widget.boilVo['userIsFollow'];
            });
            if (widget.boilVo['userIsFollow']) {
              await dio.get("/user/follow/${widget.boilVo['userId']}");
            } else {
              await dio.get("/user/unfollow/${widget.boilVo['userId']}");
            }
          },
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(
              "https://blog.icepan.cloud/${widget.boilVo["userAvatarId"]}.jpg"),
          radius: 30,
        ),
        title: Row(
          children: [
            Text(
              "${widget.boilVo['username']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(
              widget.boilVo["createTime"],
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w100,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        subtitle: Text(
          widget.boilVo["userBio"],
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(widget.boilVo['userId']),
          ),
        );
      },
    );
  }
}
