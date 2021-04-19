import 'package:flutter/material.dart';

class BoilBottom extends StatelessWidget {
  Text text;
  Icon icon;
  Map boilVo;
  Function handler;
  BoilBottom(this.text, this.icon, {this.boilVo, this.handler});
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
              icon,
              text,
            ],
          ),
        ),
        onTap: () {
          handler();
        },
      ),
    );
  }
}
