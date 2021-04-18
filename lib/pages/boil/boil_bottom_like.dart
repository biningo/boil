import 'package:flutter/material.dart';

class BoilLikeBottom extends StatefulWidget {
  int boilId;
  BoilLikeBottom(this.boilId, {Key key}) : super(key: key);

  @override
  _BoilLikeBottomState createState() => _BoilLikeBottomState(this.boilId);
}

class _BoilLikeBottomState extends State<BoilLikeBottom> {
  int boilId;
  bool flag = false;
  _BoilLikeBottomState(this.boilId);

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
              Icon(this.flag ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: this.flag ? Colors.red : Colors.grey[400]),
              Text(
                "喜欢",
                style: TextStyle(color: this.flag ? Colors.red : Colors.black),
              ),
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
