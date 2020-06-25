import 'dart:convert';
import 'dart:io';

import 'package:atlantic_app/screens/saved/saved-article.dart';
import 'package:path_provider/path_provider.dart';

class SavedArticlesStorage {
 
  Future get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
 
  Future get _localFile async {
    final path = await _localPath;
    return File('$path/savedarticles.dat');
  }
 
  Future writeFavorites(List favoritesList) async {
    try {
      final file = await _localFile;
 
      // Read the file
      String json =  jsonEncode(favoritesList);
 
      print("JSON writing to file: " + json);
 
      await file.writeAsString(json, mode: FileMode.write);
 
      return true;
 
    } catch (e) {
      print('error $e');
    }
 
    return false;
  }
 
  Future<List<SavedArticle>> readFavorites() async {
    try {
      final file = await _localFile;
 
      // Read the file
      String jsonString = await file.readAsString();
 
      print("JSON reading from file: " + jsonString);
 
      Iterable jsonMap = jsonDecode(jsonString);
 
      List<SavedArticle> favs = jsonMap.map((parsedJson) => SavedArticle.fromJson(parsedJson)).toList();
 
      return favs;
 
    } catch (e) {
      print('error');
    }
 
    return List();
  }
}