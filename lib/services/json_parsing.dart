/// Includes helper function to:
/// * Convert json to [Article]
/// * Convert json to [Comment]
import 'dart:convert';
import '../src/article.dart';
import '../src/comments.dart';

/// Converts jsonString to [Article]
Article fromJson2Article(String jsonStr) {
  try {
    return Article.fromJson(jsonDecode(jsonStr));
  } on FormatException catch (_) {
    throw const FormatException('The json is not properly formatted.');
  }
}

/// Converts jsonString to [Comment]
Comment fromJson2Comment(String jsonStr) {
  try {
    return Comment.fromJson(jsonDecode(jsonStr));
  } on FormatException catch (_) {
    throw const FormatException('The json is not properly formatted.');
  }
}

/// Converts jsonString to List<int>
List<int> fromJson2List(String jsonStr) {
  try {
    List<int> result = List<int>.from(jsonDecode(jsonStr));
    return result;
  } on FormatException catch (_) {
    throw const FormatException('The json is not properly formatted.');
  }
}
