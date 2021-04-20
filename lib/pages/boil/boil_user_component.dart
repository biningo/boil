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
              color: Colors.black),
          label: Text(
            widget.boilVo['userIsFollow'] ? "关注中" : "加关注",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          backgroundColor: widget.boilVo['userIsFollow']
              ? Colors.blue[300]
              : Colors.grey[300],
          onPressed: () {
            setState(() {
              if (GlobalState['isLogin'] == false) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/user", (route) => route == null);
                return;
              }
              widget.boilVo['userIsFollow'] = !widget.boilVo['userIsFollow'];
            });
          },
          elevation: 2,
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
              "网名:${widget.boilVo['username']}",
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
