// TODO Am i right in displaying "no internet connection" whenever I get SocketException?
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

// Creates Article. This calls _getArticle().
Widget createArticle(List<int> articles, int index) {
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
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text(
                'Top Stories',
                style: TextStyle(
                  fontFamily: 'Corben',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.yellow,
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _articles.length,
                addAutomaticKeepAlives: true,
                // cacheExtent: 1000,
                (context, index) {
                  return Dismissible(
                    key: ValueKey(_articles[index]),
                    background: Container(color: Colors.yellow),
                    onDismissed: (DismissDirection direction) =>
                        setState(() => _articles.removeAt(index)),
                    child: createArticle(_articles, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
