import 'package:boil/pages/user/user_info.dart';
import 'package:flutter/material.dart';

class BoilUserComponent extends StatefulWidget {
  Map boilVo;
  bool isFollow = false;
  BoilUserComponent(this.boilVo, {Key key}) : super(key: key);

  @override
  _BoilUserComponentState createState() => _BoilUserComponentState();
}

class _BoilUserComponentState extends State<BoilUserComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        trailing: IconButton(
          onPressed: () {
            setState(() {
              widget.boilVo['userIsFollow'] = !widget.boilVo['userIsFollow'];
            });
          },
          icon: Icon(Icons.face,
              color: widget.boilVo['userIsFollow'] ? Colors.blue : Colors.grey),
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
            builder: (context) => UserInfoPage(
              {
                "userId": widget.boilVo["userId"],
                "userAvatarId": widget.boilVo["userAvatarId"],
                "userBio": widget.boilVo["userBio"]
              },
            ),
          ),
        );
      },
    );
  }
}
