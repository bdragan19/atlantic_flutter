import 'package:flutter/material.dart';

class ArticleActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      new Padding(
          padding: EdgeInsets.only(right: 20),
          child:
              new Icon(Icons.file_upload, color: Colors.grey[600], size: 32)),
      new Icon(Icons.bookmark_border, color: Colors.grey[600], size: 32)
    ]);
  }
}
