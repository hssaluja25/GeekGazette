import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../src/article.dart';
import 'package:http/http.dart' as http;
import '../json_parsing.dart';
import 'commentpage.dart';

// Displays top stories
class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

// Returns Article object.
Future<Article> _getArticle(int id) async {
  final uri = Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return fromJson2Article(response.body);
  } else {
    return Article(title: 'Error getting the article.');
  }
}

class _ArticlePageState extends State<ArticlePage> {
  final List<int> _articles = [
    32107434,
    32106126,
    32106762,
    32080184,
    32087557,
    32104609,
    32106063,
    32104764,
    32117771,
    32120230,
    32093452,
    32105616,
    32126089,
    32115059,
    32110573,
    32126597,
    32094142,
    32106380,
    32101729,
    32110993,
    32094469,
    32120247,
    32105129,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top Stories',
          style: TextStyle(
            fontFamily: 'Corben',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: ListView(
        children: _articles
            .map(
              (id) => FutureBuilder<Article>(
                future: _getArticle(id),
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
                                          builder: (BuildContext context) =>
                                              CommentsPage(
                                                  commentIds:
                                                      snapshot.data.kids),
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
                    if (snapshot.error.toString().contains('SocketException') &&
                        snapshot.error.toString().contains('errno = 11001')) {
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
              ),
            )
            .toList(),
      ),
    );
  }
}
