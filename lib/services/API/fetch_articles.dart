import 'dart:io';

import 'fetch_individual_article.dart';
import '../../src/article.dart';

/// Receives a list of article ids and returns a list of [Article]s
/// Calls helper function [getArticle]
Future<List<Article>> getAllArticles({required List<int> articles}) async {
  List<Article> result = [];
  List<String> dismissedArticles = [];

  for (int i = 0; i < articles.length; i++) {
    try {
      Article a = await getArticle(articles[i]);
      if (!dismissedArticles.contains(a.id.toString())) {
        // If article has not been dismissed by the user, add it to results to be displayed.
        result.add(a);
      }
    } on SocketException catch (_) {
      throw const SocketException('No internet connection');
    } catch (_) {
      throw Exception('Error getting article having id: ${articles[i]}');
    }
  }
  print('Returning from API call');
  return result;
}

Stream<Article> generateArticles({required List<int> articleIds}) async* {
  List<String> dismissedArticles = [];
  for (int id in articleIds) {
    try {
      Article a = await getArticle(id);
      if (!dismissedArticles.contains(a.id.toString())) {
        // If article has not been dismissed by the user, yield it.
        yield a;
      }
    } on SocketException catch (_) {
      throw const SocketException('No internet connection');
    }
  }
}
