import 'dart:convert';
import '../src/article.dart';
import '../src/comments.dart';

// Converts jsonString (Top Stories) to list of integers (id).
List<int> fromJson2List(String jsonStr) {
  return List<int>.from(jsonDecode(jsonStr));
}

// Converts jsonString(for a particular post) to Article object.
Article fromJson2Article(String jsonStr) {
  return Article.fromJson(jsonDecode(jsonStr));
}

Comment fromJson2Comment(String jsonStr) {
  return Comment.fromJson(jsonDecode(jsonStr));
}
