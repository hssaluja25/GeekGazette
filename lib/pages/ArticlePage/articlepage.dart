import 'package:flutter/material.dart';
import 'package:hackernews/pages/error/errorpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/API/fetch_articles.dart';
import '../../src/article.dart';
import 'Custom Widgets/create_listtile.dart';

/// Finds individual story from the id of best stories
class ArticlePage extends StatefulWidget {
  final List<int> articles;
  late final List<int> first10Articles;
  Map<String, String> bookmarks;
  final String uid;
  final SharedPreferences prefs;

  ArticlePage(
      {required this.articles,
      required this.bookmarks,
      required this.uid,
      required this.prefs,
      Key? key})
      : super(key: key) {
    first10Articles = articles.sublist(0, 10);
  }

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Future<List<Article>> fetchCollectionOfArticles;

  // Moved fetchCollectionOfArticles to this class
  // so that the Future is not run multiple times due to IndexedStack
  @override
  void initState() {
    super.initState();
    fetchCollectionOfArticles = getAllArticles(
      articles: widget.first10Articles,
      prefs: widget.prefs,
    );
  }

  onPress() async {
    setState(() {
      fetchCollectionOfArticles =
          getAllArticles(articles: widget.first10Articles, prefs: widget.prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: fetchCollectionOfArticles,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print('Inside snapshot.hasData of Article Page');
          print("Now, articles length = ${snapshot.data.length}");
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
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Article article = snapshot.data[index];
                    bool isBookmarked =
                        widget.bookmarks.containsKey(article.id.toString());

                    return Dismissible(
                      key: ValueKey(article.id),
                      background: Container(
                        color: Colors.yellow,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.05089 * width),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/trash.gif',
                                height: 0.0479 * height,
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.yellow,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0.05089 * width),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/icons/trash.gif',
                                height: 0.0479 * height,
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: CreateListtile(
                        article: article,
                        bookmarks: widget.bookmarks,
                        uid: widget.uid,
                        isBookmarked: isBookmarked,
                      ),
                      onDismissed: (DismissDirection direction) {
                        // Store current article in list of dismissed articles
                        // st we know not to display it in future
                        // NOTE: Bookmarked articles can also be dismissed from
                        // article tab but they are stil visible in the bookmarks tab
                        List<String> dismissedArticles =
                            widget.prefs.getStringList('dismissed') ?? [];
                        dismissedArticles.add(article.id.toString());
                        widget.prefs
                            .setStringList('dismissed', dismissedArticles);
                        setState(() {
                          snapshot.data.remove(article);
                        });
                        print("Now, articles length = ${snapshot.data.length}");
                      },
                    );
                  },
                  addAutomaticKeepAlives: true,
                  childCount: (snapshot.data).length,
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
