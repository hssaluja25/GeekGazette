import 'package:http/http.dart' as http;
import 'dart:io';

import '../../src/comments.dart';
import '../json_parsing.dart';

/// Makes a network call to HackerNews API and returns a Comment object.
Future<Comment> getComment(int id) async {
  try {
    final myUri =
        Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
    final response = await http.get(myUri);
    return fromJson2Comment(response.body);
  } on SocketException catch (_) {
    throw SocketException('Error getting comment: $id');
  } on HttpException catch (_) {
    throw HttpException('Error getting comment: $id');
  } on Exception catch (_) {
    throw Exception('Error getting comment: $id');
  }
}
