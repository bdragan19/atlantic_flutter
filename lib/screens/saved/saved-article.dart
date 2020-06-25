class SavedArticle {
  int pk;
  String title;
  String author;
  String image;
  String footerTitle;

  SavedArticle(
      {this.pk, this.title, this.author, this.image, this.footerTitle});

  factory SavedArticle.fromJson(Map<String, dynamic> json) {
    return SavedArticle(
        pk: json['pk'],
        title: json['title'],
        author: json['author'],
        image: json['image'],
        footerTitle: json['footerTitle']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pk': this.pk,
        'title': this.title,
        'author': this.author,
        'image': this.image,
        'footerTitle': this.footerTitle
      };
}
