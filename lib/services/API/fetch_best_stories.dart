import 'dart:io';
import 'package:hackernews/services/json_parsing.dart';
import 'package:http/http.dart' as http;

/// Returns a list of integers representing the id of best stories
Future<List<int>> fetchBestStories() async {
  try {
    final Uri uri =
        Uri.parse('https://hacker-news.firebaseio.com/v0/beststories.json');
    final response = await http.get(uri);
    List<int> listOfBestStories = fromJson2List(response.body);
    return listOfBestStories.sublist(0, 50);
  } on SocketException catch (_) {
    throw const SocketException('Check your internet connection');
  }
}
