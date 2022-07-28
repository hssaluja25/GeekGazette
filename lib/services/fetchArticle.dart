import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../src/article.dart';
import '../UI/commentpage.dart';
import 'json_parsing.dart';

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
                        child: Text('${snapshot.data.kids.length} comments'),
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => CommentsPage(
                                    commentIds: snapshot.data.kids),
                              ),
                            );
                          } else {
                            SnackBar snackbar = SnackBar(
                                content: const Text('No Internet Connection'));
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(snackbar);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.launch),
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.mobile) {
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
                        } else {
                          SnackBar snackbar = SnackBar(
                              content: const Text('No Internet Connection'));
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(snackbar);
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
