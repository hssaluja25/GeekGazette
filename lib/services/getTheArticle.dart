import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../src/article.dart';
import '../UI/commentpage.dart';
import '../json_parsing.dart';

// Gets Article from API.
Future<Article> _getArticle(int id) async {
  final uri = Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return fromJson2Article(response.body);
  } else {
    return Article(title: 'Error getting the article.');
  }
}

// Displays Article by making a network call. The actual network call is made by _getArticle
Widget displayArticle(List<int> articles, int index) {
  return FutureBuilder<Article>(
    future: _getArticle(articles[index]),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.title != null) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(snapshot.data!.title),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                        child: Text('${snapshot.data.descendants} comments'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CommentsPage(commentIds: snapshot.data.kids),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.launch),
                      onPressed: () async {
                        final urlOfArticle = Uri.parse(snapshot.data.url);
                        // TODO Come here for adding progress indicator to webview.
                        if (await canLaunchUrl(urlOfArticle)) {
                          launchUrl(urlOfArticle);
                        } else {
                          // Display a dialog box saying that the URL could not be launched.
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'There was an error opening the web page'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          // The article was deleted
          return Container();
        }
      } else if (snapshot.hasError) {
        // This is probably not right.
        if (snapshot.error.toString().contains('SocketException')) {
          return const ListTile(
            title: Text('No internet connection'),
          );
        }
        // For other errors
        return ListTile(
          title: Text('${snapshot.error}'),
          onTap: () {},
        );
      }
      // By default, show a loading spinner.
      return const Center(child: CircularProgressIndicator());
    },
  );
}
