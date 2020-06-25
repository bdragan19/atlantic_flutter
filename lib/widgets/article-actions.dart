import 'package:flutter/material.dart';

class ArticleActions extends StatefulWidget {
  final void Function(bool isSaved) onSavedChanged;
  final bool isSaved;

  ArticleActions({Key key, this.isSaved, this.onSavedChanged})
      : super(key: key);

  _ArticleActionsState createState() => _ArticleActionsState();
}

class _ArticleActionsState extends State<ArticleActions> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved;
  }

  void toggleSaved() {
    setState(() {
      isSaved = !isSaved;
      widget.onSavedChanged(isSaved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      new IconButton(
              icon: new Icon(Icons.file_upload,
                  color: Colors.grey[600], size: 32),
              onPressed: () {
                print("button presed");
              }),
      new IconButton(
        icon: new Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? Colors.red[600] : Colors.grey[600], size: 32),
        onPressed: () {
          toggleSaved();
        },
      )
    ]);
  }
}
