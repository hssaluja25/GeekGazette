import 'package:http/http.dart' as http;
import 'dart:io';

import '../src/comments.dart';
import '../json_parsing.dart';

/// Makes a network call to HackerNews API and returns a Comment object.
Future<Comment> getComment(int id) async {
  final myUri =
      Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(myUri);
  if (response.statusCode == 200) {
    return fromJson2Comment(response.body);
  } else {
    // What does this do? Is it even executed? Or snapshot.error is executed?
    throw HttpException('${response.statusCode}');
  }
}
