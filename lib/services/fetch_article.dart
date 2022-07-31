import 'dart:io';
import 'package:http/http.dart' as http;

import 'json_parsing.dart';
import '../src/article.dart';

// Gets Article from API.
Future<Article> getArticle(int id) async {
  try {
    final uri =
        Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
    final response = await http.get(uri);
    // If you give an invalid id, response.body would be 'null' (in string)
    // would be returned.
    if (response.body != 'null') {
      return fromJson2Article(response.body);
    } else {
      throw Exception('Invalid id');
    }
  } on SocketException catch (error) {
    throw SocketException('Error getting the article having id $id');
  } on HttpException catch (error) {
    throw HttpException('Error getting the article having id $id');
  } on Exception catch (error) {
    throw Exception('$error');
  }
}
