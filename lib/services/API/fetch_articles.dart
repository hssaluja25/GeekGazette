import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import 'fetch_individual_article.dart';
import '../../src/article.dart';

/// Receives a list of article ids and returns a list of [Article]s
/// Calls helper function [getArticle]
Future<List<Article>> getAllArticles(
    {required List<int> articles, required SharedPreferences prefs}) async {
  List<Article> result = [];
  List<String> dismissedArticles = prefs.getStringList('dismissed') ?? [];

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
