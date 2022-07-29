import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../src/article.dart';
import '../UI/commentpage.dart';
import 'json_parsing.dart';

// Gets Article from API.
Future<Article> getArticle(int id) async {
  try {
    final uri =
        Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
    final response = await http.get(uri);
    // If you give an invalid id, response.body would be 'null' (in string)
    // would be returned.
    if (response.body != 'null') {
      return fromJson2Article(response.body);
    } else {
      throw Exception('Invalid id');
    }
  } on SocketException catch (error) {
    throw SocketException('Error getting the article having id $id');
  } on HttpException catch (error) {
    throw HttpException('Error getting the article having id $id');
  } on Exception catch (error) {
    throw Exception('$error');
  }
}

// Displays Article by making a network call. The actual network call is made by
// getArticle
Widget displayArticleOrError(List<int> articles, int index) {
  return FutureBuilder<Article>(
    future: getArticle(articles[index]),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.title != null) {
          return displayArticle(snapshot);
        } else {
          // The article was deleted
          return Container();
        }
      } else if (snapshot.hasError) {
        // If there is an error getting an inidividual article, it won't be
        // displayed.
        return Container();
      }
      // By default, show a loading spinner.
      return const Center(child: CircularProgressIndicator());
    },
  );
}

String formatDate(int milliseconds) {
  final template = DateFormat('MMM dd');
  return template.format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}

class displayArticle extends StatelessWidget {
  final snapshot;
  displayArticle(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${snapshot.data!.by} · ${formatDate(snapshot.data!.time)}',
              style: TextStyle(fontSize: 14),
            ),
            Text(snapshot.data!.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bookmark,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.comment,
                    size: 20,
                  ),
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CommentsPage(commentIds: snapshot.data.kids),
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
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.shareNodes,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        onTap: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());
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
                    content:
                        const Text('There was an error opening the web page'),
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
            SnackBar snackbar =
                SnackBar(content: const Text('No Internet Connection'));
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackbar);
          }
        },
      ),
    );
  }
}
