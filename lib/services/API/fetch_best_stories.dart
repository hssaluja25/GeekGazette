import 'dart:io';
import 'package:http/http.dart' as http;
import '../json_parsing.dart';

Future<List<int>> getBestStories() async {
  try {
    final Uri uri =
        Uri.parse('https://hacker-news.firebaseio.com/v0/beststories.json');
    final response = await http.get(uri);
    List<int> originalList = fromJson2List(response.body);
    // We would be displaying best 50 stories instead of best 200.
    return originalList.sublist(0, 50);
  } on SocketException catch (error) {
    throw const SocketException('Error getting best stories');
  } on HttpException catch (error) {
    throw const HttpException('Error getting best stories');
  } on Exception catch (error) {
    throw Exception('Error getting best stories');
  }
}
