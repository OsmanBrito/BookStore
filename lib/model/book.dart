import 'package:equatable/equatable.dart';

class Book extends Equatable {
  Book({
    this.id,
    this.title,
    this.author,
    this.description,
    this.thumbnail,
    this.bookUrl,
    this.isFavorite = false,
  });

  String? id;
  String? title;
  String? author;
  String? description;
  String? thumbnail;
  String? bookUrl;
  bool isFavorite = false;

  factory Book.fromApi(Map<String, dynamic> data) {
    String getThumbnailSafety(Map<String, dynamic> data) {
      final imageLinks = data['volumeInfo']['imageLinks'];
      if (imageLinks != null && imageLinks['thumbnail'] != null) {
        return imageLinks['thumbnail'];
      } else {
        return "";
      }
    }

    return Book(
      id: data['id'],
      author: data['volumeInfo']['authors'][0],
      bookUrl: data['volumeInfo']['previewLink'],
      description: data['volumeInfo']['description'],
      title: data['volumeInfo']['title'],
      thumbnail: getThumbnailSafety(data).replaceAll("http", "https"),
    );
  }

  static String getAuthorsSafety(List<dynamic>? authors) {
    if (authors == null) {
      return "Without authors";
    } else {
      return authors[0];
    }
  }

  static String getThumbnailSafety(Map<String, dynamic> data) {
    final imageLinks = data['volumeInfo']['imageLinks'];
    if (imageLinks != null && imageLinks['thumbnail'] != null) {
      return imageLinks['thumbnail'];
    } else {
      return "https://yt3.ggpht.com/ytc/AKedOLR0Q2jl80Ke4FS0WrTjciAu_w6WETLlI0HmzPa4jg=s176-c-k-c0x00ffffff-no-rj";
    }
  }

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    bookUrl = json['bookUrl'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['author'] = author;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['bookUrl'] = bookUrl;
    data['isFavorite'] = isFavorite;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        thumbnail,
        bookUrl,
        isFavorite,
      ];
}
