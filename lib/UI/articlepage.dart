import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../services/display_article.dart';
import '../services/fetch_best_stories.dart';
import '../src/article.dart';
import '../services/fetch_article.dart';

// Displays best stories
class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<int> _articles = [];
  bool _successFetchingStories = true;

  @override
  void initState() {
    super.initState();
    getBestStories()
        .then((value) => setState(() => _articles = value))
        .catchError(
            (onError) => setState(() => _successFetchingStories = false));
  }

  @override
  Widget build(BuildContext context) {
    if (!_successFetchingStories) {
      return RefreshIndicator(
        onRefresh: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          // Internet Connection reestablished.
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            List<int> tempList = await getBestStories();
            setState(() {
              _articles = tempList;
              _successFetchingStories = true;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(': ('),
            backgroundColor: Colors.red,
          ),
          body: ListView(children: [Image.asset('assets/images/aw_snap.jpg')]),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          // User has internet connection.
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            List<int> tempList = await getBestStories();
            setState(() => _articles = tempList);
          } else {
            setState(() => _successFetchingStories = false);
          }
        },
        child: Scaffold(
          body: CustomScrollView(
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
                  childCount: _articles.length,
                  addAutomaticKeepAlives: true,
                  (context, index) {
                    int articleIdAtIndex = _articles[index];
                    return Dismissible(
                      key: ValueKey(_articles[index]),
                      background: Container(
                        color: Colors.yellow,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/trash.gif',
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.yellow,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/icons/trash.gif',
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() => _articles.removeAt(index));
                        SnackBar snackbar = SnackBar(
                          content: const Text('Removed'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() =>
                                  _articles.insert(index, articleIdAtIndex));
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(snackbar);
                      },
                      child: FutureBuilder<Article>(
                        future: getArticle(_articles[index]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // ! Make notes in copy
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Colors.blueAccent.shade400,
            selectedItemColor: Colors.yellow,
            unselectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmarks_rounded),
                label: 'Bookmark',
              ),
            ],
          ),
        ),
      );
    }
  }
}
