import 'package:flutter/material.dart';
import 'package:hackernews/pages/error/errorpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/API/fetch_articles.dart';
import '../../src/article.dart';
import 'display_all_articles.dart';

/// Finds individual story from the id of best stories
class ArticlePage extends StatefulWidget {
  final List<int> articles;
  late final List<int> first10Articles;
  late Future<List<Article>> fetchCollectionOfArticles;
  SharedPreferences prefs;
  List<String> bookmarks;

  ArticlePage(
      {required this.articles,
      required this.bookmarks,
      required this.prefs,
      Key? key})
      : super(key: key) {
    first10Articles = articles.sublist(0, 10);
    fetchCollectionOfArticles = getAllArticles(first10Articles);
  }

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  onPress() async {
    setState(() {
      widget.fetchCollectionOfArticles = getAllArticles(widget.first10Articles);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: widget.fetchCollectionOfArticles,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print('Inside snapshot.hasData of Article Page');
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text(
                  'Home',
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
                delegate: SliverChildListDelegate(
                  addAutomaticKeepAlives: true,

                  /// We pass a list of [Article]s to this helper function
                  displayCollectionOfArticles(
                    articles: snapshot.data,
                    context: context,
                    bookmarks: widget.bookmarks,
                    prefs: widget.prefs,
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          print(snapshot.error);
          return ErrorPage(height: height, onPress: onPress);
        } else {
          return Center(
            child: Image.asset('assets/images/loading.gif'),
          );
        }
      },
    );
  }
}
