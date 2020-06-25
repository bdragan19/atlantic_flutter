import 'dart:convert';
//import 'dart:io';
import 'package:atlantic_app/screens/saved/saved-article.dart';
import 'package:atlantic_app/screens/saved/saved-articles.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class LatestPage extends StatefulWidget {
  LatestPage({Key key}) : super(key: key);

  final SavedArticles savedArticles = SavedArticles();

  updateSaved(SavedArticle article, bool isSaved) async {
    if (!isSaved) {
      await savedArticles.addToSaved(article);
    } else {
      await savedArticles.removeFromSaved(article);
    }
  }

  @override
  LatestPageState createState() => LatestPageState();
}

class LatestPageState extends State<LatestPage> {
  List<dynamic> _articles = [];
  final _dioCacheManager = DioCacheManager(CacheConfig());
  Dio _dio = Dio();

  void fetchArticles({bool skipCache = false}) async {

    Options _cacheOptions;
    if(kIsWeb){
      _cacheOptions = Options(responseType: ResponseType.bytes);
    }else{
      _cacheOptions = buildCacheOptions(Duration(minutes: 30),
        forceRefresh: skipCache,
        options: Options(responseType: ResponseType.bytes));
      
      _dio.interceptors.add(_dioCacheManager.interceptor);
    }

    _dio.options.headers["Authorization"] = "token " + DotEnv().env['TOKEN'];

    try{
    final response = await _dio.get(
      DotEnv().env['API_URL'] + "/articles",
      options: _cacheOptions 
    );

    if (response.statusCode == 200) {
      //final jsonObj = json.decode(Utf8Decoder().convert(response.bodyBytes));
      // List<Studentdata> studentList = items.map<Studentdata>((json) {
      //   return Studentdata.fromJson(json);
      // }).toList();

      // return jsonObj['results'];

      if (mounted) {
        setState(() {
          _articles =
              json.decode(Utf8Decoder().convert(response.data))['results'];
        });
      }
    } else {
      print("Failed to load data from Server. StatusCode: " +
          response.statusCode.toString());
    }
    } catch(ex){
      print("Failed to load data from Server. StatusCode: " +
          ex.toString());
    }
  }

  Future<void> refreshArticles() async {
    if (mounted) {
      setState(() {
        fetchArticles(skipCache: true);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadSavedArticles();
    fetchArticles();
  }

  loadSavedArticles() async {
    List<SavedArticle> savedArticles =
        await widget.savedArticles.readAllSaved();

    setState(() {
      widget.savedArticles.saved = savedArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            //       child: new Center(
            // child: FutureBuilder(
            //     future: fetchArticles(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Center(child: new Text(snapshot.error.toString()));
            //       }

            //       if (!snapshot.hasData) {
            //         return Center(
            //             child: CircularProgressIndicator(
            //                 valueColor:
            //                     new AlwaysStoppedAnimation<Color>(Colors.grey[500])));
            //       }

            //       var articles = snapshot.data;

            child: _articles.length != 0
                ? RefreshIndicator(
                    child: ListView.separated(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      itemCount: _articles == null ? 0 : _articles.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                              color: Color.fromRGBO(200, 199, 204, 1),
                              thickness: 0.7),
                      itemBuilder: (BuildContext context, int index) {
                        final article = _articles[index];

                        final imageUrl =
                            article["image"]["thumbs"]["app_square"]["url"];
                        final title = article["title"];
                        final author = article["authors"].length > 0
                            ? article["authors"][0]["name"]
                            : "Unknown";
                        final pk = article["pk"];

                        final footerTitle = article["footer"]["title"];

                        final savedArticle = SavedArticle(
                            author: author,
                            pk: pk,
                            title: title,
                            image: imageUrl,
                            footerTitle: footerTitle);

                        final isArticleSaved =
                            widget.savedArticles.isSaved(savedArticle);

                        return new InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/article',
                                      arguments: pk)
                                  .then((value) => setState(() {}));
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            HtmlWidget(title,
                                                textStyle: TextStyle(
                                                  fontFamily: "AGaramond",
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 26,
                                                )),
                                            new Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: new Text("By " + author,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily: "AGaramond",
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 22)))
                                          ]),
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(bottom: 25, top: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Text(footerTitle,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.red[600])),
                                        new Row(children: <Widget>[
                                          new IconButton(
                                                  icon: Icon(Icons.file_upload,
                                                      color: Colors.grey[600],
                                                      size: 32),
                                                  onPressed: () {
                                                    print("button presed");
                                                  }),
                                          new IconButton(
                                            icon: new Icon(
                                                isArticleSaved
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color: isArticleSaved
                                                    ? Colors.red[600]
                                                    : Colors.grey[600],
                                                size: 32),
                                            onPressed: () {
                                              setState(() {
                                                print("isSaved " +
                                                    isArticleSaved.toString());
                                                widget.updateSaved(savedArticle,
                                                    isArticleSaved);
                                              });
                                            },
                                          )
                                        ])
                                      ]))
                            ]));
                      },
                    ),
                    onRefresh: refreshArticles,
                    color: Colors.red[600],
                  )
                : Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.grey[500])))));
  }
}
