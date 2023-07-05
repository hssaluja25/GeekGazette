import 'package:http/http.dart' as http;

import '../json_parsing.dart';
import '../../src/article.dart';

/// Receives article id and returns an [Article]
Future<Article> getArticle(int id) async {
  final uri = Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(uri);
  // If article id is invalid, response.body would be 'null' (string datatype)
  if (response.body != 'null') {
    return fromJson2Article(response.body);
  } else {
    throw Exception('Invalid id: $id');
  }
}

// Stream<Article> generateArticle(int id) async* {
//   try {
//     final uri =
//         Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
//     final response = await http.get(uri);
//     // If article id is invalid, response.body would be 'null' (string datatype)
//     if (response.body != 'null') {
//       yield fromJson2Article(response.body);
//     } else {
//       throw Exception('Invalid id: $id');
//     }
//   } on SocketException catch (_) {
//     throw const SocketException('Check your internet connection');
//   }
// }
