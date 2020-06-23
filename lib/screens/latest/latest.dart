import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class LatestPage extends StatefulWidget {
  LatestPage({Key key}) : super(key: key);

  @override
  LatestPageState createState() => LatestPageState();
}

class LatestPageState extends State<LatestPage> {
  Future<List> fetchArticles() async {
    final response = await http.get(DotEnv().env['API_URL'] + "/articles",
        headers: {
          HttpHeaders.authorizationHeader: "token " + DotEnv().env['TOKEN']
        });

    if (response.statusCode == 200) {
      final jsonObj = json.decode(Utf8Decoder().convert(response.bodyBytes));
      // List<Studentdata> studentList = items.map<Studentdata>((json) {
      //   return Studentdata.fromJson(json);
      // }).toList();

      return jsonObj['results'];
    } else {
      throw Exception("Failed to load data from Server. StatusCode: " +
          response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            child: new Center(
      child: FutureBuilder(
          future: fetchArticles(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: new Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey[500])));
            }

            var articles = snapshot.data;

            return new ListView.separated(
              padding: EdgeInsets.only(left: 30, right: 30),
              itemCount: articles == null ? 0 : articles.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Color.fromRGBO(200, 199, 204, 1), thickness: 0.7),
              itemBuilder: (BuildContext context, int index) {
                final article = articles[index];

                final imageUrl =
                    article["image"]["thumbs"]["app_square"]["url"];
                final title = article["title"];
                final author = article["authors"].length > 0
                    ? article["authors"][0]["name"]
                    : "Unknown";

                final footerTitle = article["footer"]["title"];
                return new InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/article',
                          arguments: article["pk"]);
                    },
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: imageUrl,
                              width: 130,
                              height: 130,
                            ),
                            Flexible(
                                child: new Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    HtmlWidget(title,
                                        textStyle: TextStyle(
                                          fontFamily: "AGaramond",
                                          fontWeight: FontWeight.w900,
                                          fontSize: 26,
                                        )),
                                    new Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: new Text("By " + author,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: "AGaramond",
                                                fontStyle: FontStyle.italic,
                                                fontSize: 22)))
                                  ]),
                            )),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 25, top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(footerTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.red[600])),
                                new Row(children: <Widget>[
                                  new Padding(
                                      padding: EdgeInsets.only(right: 25),
                                      child: new Icon(Icons.file_upload,
                                          color: Colors.grey[600], size: 32)),
                                  new Icon(Icons.bookmark_border,
                                      color: Colors.grey[600], size: 32)
                                ])
                              ]))
                    ]));
              },
            );
          }),
    )));
  }
}
