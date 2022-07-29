import 'dart:io';
import 'package:http/http.dart' as http;
import 'json_parsing.dart';

Future<List<int>> getBestStories() async {
  try {
    final Uri uri =
        Uri.parse('https://hacker-news.firebaseio.com/v0/beststories.json');
    final response = await http.get(uri);
    return fromJson2List(response.body);
  } on SocketException catch (error) {
    throw const SocketException('Error getting best stories');
  } on HttpException catch (error) {
    throw const HttpException('Error getting best stories');
  } on Exception catch (error) {
    throw Exception('Error getting best stories');
  }
}
