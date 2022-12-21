import '../../src/article.dart';
import 'dart:io';

import 'fetch_individual_article.dart';

/// Receives a list of article ids and returns a list of [Article]s
/// Calls helper function [getArticle]
Future<List<Article>> getAllArticles(List<int> articles) async {
  List<Article> result = [];
  for (int i = 0; i < articles.length; i++) {
    try {
      Article a = await getArticle(articles[i]);
      result.add(a);
    } on SocketException catch (_) {
      throw const SocketException('No internet connection');
    } catch (_) {
      throw Exception('Error getting article having id: ${articles[i]}');
    }
  }
  return result;
}

// Should be used later when user hits the bottom of the FutureBuilder
// Stream<Article> getAllArticles(List<int> articles) async* {
//   for (int id in articles) {
//     try {
//       Article a = await getArticle(id);
//       yield a;
//     } catch (error) {
//       print('Error getting article having id: $id.\n$error');
//     }
//   }
// }
