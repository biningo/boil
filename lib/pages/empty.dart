import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Wrap(
      children: [
        Icon(Icons.hourglass_empty),
        Text(
          "空空如也....",
          style: TextStyle(fontSize: 20),
        )
      ],
    ));
  }
}
