import 'package:atlantic_app/screens/saved/saved-article.dart';
import 'package:atlantic_app/screens/saved/saved-articles-storage.dart';

class SavedArticles {

  // static final SavedArticles _singleton = SavedArticles._internal();

  // factory SavedArticles() {
  //   return _singleton;
  // }

  // SavedArticles._internal();

  SavedArticles._privateConstructor();

  static final SavedArticles _instance = SavedArticles._privateConstructor();

  factory SavedArticles() {
    return _instance;
  }

  SavedArticlesStorage storage = SavedArticlesStorage();
  List<SavedArticle> saved = [];

  Future<List<SavedArticle>> readAllSaved() async {
    saved = await storage.readFavorites();
    return saved;
  }

  Future addToSaved(SavedArticle article) async {
    if (!saved.any((s) => s.pk == article.pk)) {
      saved.add(article);

      await storage.writeFavorites(saved);
    }
  }

  Future removeFromSaved(SavedArticle article) async {
    saved.removeWhere((s) => s.pk == article.pk);

    await storage.writeFavorites(saved);
  }

  bool isSaved(SavedArticle article) {
    return saved.any((s) => s.pk == article.pk);
  }
}