import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
          return DisplayArticle(snapshot);
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

class DisplayArticle extends StatefulWidget {
  final AsyncSnapshot snapshot;
  const DisplayArticle(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<DisplayArticle> createState() => _DisplayArticleState();
}

class _DisplayArticleState extends State<DisplayArticle> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.snapshot.data!.by} · ${formatDate(widget.snapshot.data!.time)}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(widget.snapshot.data!.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: _isBookmarked == true
                      ? const FaIcon(FontAwesomeIcons.solidBookmark,
                          size: 20, color: Colors.yellow)
                      : const FaIcon(FontAwesomeIcons.bookmark, size: 20),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    const key = 'bookmarks';
                    final bookmarkedArticles = prefs.getStringList(key) ?? [];
                    if (!_isBookmarked) {
                      bookmarkedArticles.add('${widget.snapshot.data!.id}');
                      prefs.setStringList(key, bookmarkedArticles);
                      setState(() => _isBookmarked = true);
                    } else {
                      bookmarkedArticles.remove('${widget.snapshot.data!.id}');
                      prefs.setStringList(key, bookmarkedArticles);
                      setState(() => _isBookmarked = false);
                    }
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.comment,
                    size: 20,
                  ),
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CommentsPage(
                              commentIds: widget.snapshot.data.kids),
                        ),
                      );
                    } else {
                      SnackBar snackbar = const SnackBar(
                          content: Text('No Internet Connection'));
                      if (!mounted) return;
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackbar);
                    }
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.shareNodes,
                    size: 20,
                  ),
                  onPressed: () {
                    Share.share(
                      widget.snapshot.data!.url,
                      subject: 'Check out this article from Hacker News',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        onTap: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.wifi ||
              connectivityResult == ConnectivityResult.mobile) {
            final urlOfArticle = Uri.parse(widget.snapshot.data.url);
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
                const SnackBar(content: Text('No Internet Connection'));
            if (!mounted) return;
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackbar);
          }
        },
      ),
    );
  }
}
