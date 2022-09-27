import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../json_parsing.dart';
import '../../src/article.dart';

// Gets Article from API.
Future<Article> getArticle(int id) async {
  final log = Logger('Fetch Article');
  log.info('Fetching the article now');
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

Future<List> getAllArticles(List<int> articles) async {
  // Make a better variable name.
  List<Future> result = [];
  for (int articleId in articles) {
    result.add(getArticle(articleId));
  }
  return Future.wait(result);
}
