import 'dart:convert';
import '../src/article.dart';
import '../src/comments.dart';

// Converts jsonString (Best Stories) to list of integers (id).
List<int> fromJson2List(String jsonStr) {
  try {
    return List<int>.from(jsonDecode(jsonStr));
  } on FormatException catch (error) {
    throw const FormatException('The json is properly formatted.');
  }
}

// Converts jsonString(for a particular post) to Article object.
Article fromJson2Article(String jsonStr) {
  try {
    return Article.fromJson(jsonDecode(jsonStr));
  } on FormatException catch (error) {
    throw const FormatException('The json is properly formatted.');
  }
}

Comment fromJson2Comment(String jsonStr) {
  try {
    return Comment.fromJson(jsonDecode(jsonStr));
  } on FormatException catch (error) {
    throw const FormatException('The json is properly formatted.');
  }
}
