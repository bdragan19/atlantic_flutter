import 'package:flutter/material.dart';

class AtlanticAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  AtlanticAppBar(
      {@required this.title, this.child, this.onPressed, this.onTitleTapped})
      : preferredSize = Size.fromHeight(90.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 0, 10),
          child: Text(title.toUpperCase(),
              style: TextStyle(
                  fontFamily: "Atlantic-Serif",
                  fontSize: 40,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400)),
        ),
        Divider(color: Color.fromRGBO(200, 199, 204, 1), thickness: 1)
      ],
    ));
  }
}
