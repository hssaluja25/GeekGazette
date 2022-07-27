import 'dart:io';
import 'package:http/http.dart' as http;
import 'json_parsing.dart';

Future<List<int>> getBestStories() async {
  final Uri uri =
      Uri.parse('https://hacker-news.firebaseio.com/v0/beststories.json');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return fromJson2List(response.body);
  } else {
    throw HttpException('Error getting best stories');
  }
}
