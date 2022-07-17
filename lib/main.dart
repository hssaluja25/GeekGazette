// TODO Find a library that properly converts JSON text to String. Example ' is converted to &#x27;
// TODO Add refresh indicator and key.
// TODO Add Progress bar indicator to open Webpages OR open in external application I have added a TODO just above it could be added. So search for TODO.
// TODO Not all comments are being displayed for a particular post.
import 'package:flutter/material.dart';
// 👇 Needed to change the status bar color.
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';
import 'package:http/http.dart' as http;
import 'json_parsing.dart';
import 'src/comments.dart';

void main() {
  runApp(const MyApp());
}

// Calls the HomePage widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HackerNews Reader',
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.yellow,
        ),
        child: SafeArea(child: MyHomePage()),
      ),
    );
  }
}

// Displays top stories
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Makes a network call and returns an Article object. It is passed to FutureBuilder.
Future<Article> _getArticleForThisId(int id) async {
  final uri = Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return fromJson2Article(response.body);
  } else {
    return Article(title: 'Error getting the article.');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> _articles = [
    32107434,
    32106126,
    32106762,
    32080184,
    32087557,
    32104609,
    32106063,
    32104764
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Stories'),
        backgroundColor: Colors.yellow[700],
      ),
      body: ListView(
        children: _articles
            .map(
              (id) => FutureBuilder<Article>(
                future: _getArticleForThisId(id),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                    child: Text(
                                        '${snapshot.data.descendants} comments'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Scaffold(
                                              appBar: AppBar(
                                                title: const Text('Comments'),
                                                backgroundColor:
                                                    Colors.yellow[700],
                                              ),
                                              body: CommentsPage(
                                                  commentsIds:
                                                      snapshot.data.kids),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.launch),
                                  onPressed: () async {
                                    final urlOfArticle =
                                        Uri.parse(snapshot.data.url);
                                    // TODO Come here for adding progress indicator to webview.
                                    if (await canLaunchUrl(urlOfArticle)) {
                                      launchUrl(
                                        urlOfArticle,
                                        mode: LaunchMode.inAppWebView,
                                        webViewConfiguration:
                                            const WebViewConfiguration(),
                                      );
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
                                                onPressed: () =>
                                                    Navigator.pop(context),
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
                    return ListTile(title: Text('${snapshot.error}'));
                  }
                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

// Makes a network call and returns a Comment object
Future<Comment> getComment(int id) async {
  final myUri =
      Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(myUri);
  if (response.statusCode == 200) {
    return fromJson2Comment(response.body);
  } else {
    return const Comment(
      by: '',
      id: 0,
      parent: 0,
      text: 'There was an error making the network call',
      time: 0,
      type: '',
    );
  }
}

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key, required this.commentsIds}) : super(key: key);
  final List? commentsIds;

  @override
  Widget build(BuildContext context) {
    return commentsIds == null || commentsIds == []
        ? const Center(
            child: Text(
            'There are no comments on this post.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))
        : ListView(
            addAutomaticKeepAlives: false,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            children: commentsIds!
                .map(
                  (id) => FutureBuilder(
                      future: getComment(id),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          // Comment was probably deleted if the comment's text returns null
                          if (snapshot.data.text != null) {
                            return ListTile(
                              leading: const Icon(Icons.account_circle_sharp),
                              title: Text('${snapshot.data.text}'),
                              dense: true,
                              onTap: () {},
                            );
                          } else {
                            // The comment was deleted by the user. The else block is necessary otherwise the CircularProgressIndicator is built (as there is no return statement).
                            return Container();
                          }
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text('${snapshot.error}'),
                            onTap: () {},
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                )
                .toList(),
          );
  }
}
