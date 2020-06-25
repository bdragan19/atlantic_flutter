import 'dart:io';
import 'dart:convert';

import 'package:atlantic_app/screens/saved/saved-article.dart';
import 'package:atlantic_app/screens/saved/saved-articles.dart';
import 'package:atlantic_app/widgets/article-actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;

class ArticlePage extends StatefulWidget {
  ArticlePage({Key key}) : super(key: key);

  final SavedArticles savedArticles = SavedArticles();

  updateSaved(SavedArticle article, bool isSaved) async {
    if (isSaved) {
      await savedArticles.addToSaved(article);
    } else {
      await savedArticles.removeFromSaved(article);
    }
  }

  @override
  ArticlePageState createState() => ArticlePageState();
}

class ArticlePageState extends State<ArticlePage> {
  Future fetchArticleByPK(int pk) async {
    final response = await http
        .get(DotEnv().env['API_URL'] + "/articles/" + pk.toString(), headers: {
      HttpHeaders.authorizationHeader: "token " + DotEnv().env['TOKEN']
    });

    if (response.statusCode == 200) {
      //print(response.body);
      final jsonObj = json.decode(Utf8Decoder().convert(response.bodyBytes));

      return jsonObj;
    } else {
      throw Exception("Failed to load data from Server. StatusCode: " +
          response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final pk = ModalRoute.of(context).settings.arguments;

    final savedArticle = SavedArticle(pk: pk);

    final isSaved = widget.savedArticles.isSaved(savedArticle);

    return Scaffold(
        appBar: AppBar(actions: [
          ArticleActions(isSaved: isSaved, onSavedChanged: (isSaved){
            widget.updateSaved(savedArticle, isSaved);
          })                      
        ]),
        body: new Container(
            child: FutureBuilder(
                future: fetchArticleByPK(pk),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: new Text(snapshot.error.toString()));
                  }

                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.grey[500])));
                  }

                  var article = snapshot.data;

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: HtmlWidget(article["title"],
                                  textStyle: TextStyle(
                                      fontFamily: "AGaramond",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600))),
                          HtmlWidget(article["content"],
                          buildAsync: false,
                              hyperlinkColor: Colors.black,
                              textStyle: TextStyle(
                                  fontFamily: "AGaramond", fontSize: 26, height: 1.5)),
                        ],
                      ));

                  // return CustomScrollView(slivers: <Widget>[
                  //   Text("dededede")
                  //   //Text(article["content"])
                  // ]);
                  // return Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: <Widget>[
                  //         Text(article["content"])
                  //       ]);
                })));
  }
}
