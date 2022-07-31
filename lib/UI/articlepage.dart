import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'bookmarkpage.dart';
import 'handle_article_display.dart';
import '../services/fetch_best_stories.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<int> _articlesId = [];
  bool _successFetchingStories = true;
  int _currentIndex = 0;

  // Initializes _articlesId
  @override
  void initState() {
    super.initState();
    getBestStories()
        .then((value) => setState(() => _articlesId = value))
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
              _articlesId = tempList;
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
            setState(() => _articlesId = tempList);
          } else {
            setState(() => _successFetchingStories = false);
          }
        },
        child: Scaffold(
          body: _currentIndex == 1
              ? const BookmarkPage()
              : CustomScrollView(
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
                        childCount: _articlesId.length,
                        addAutomaticKeepAlives: true,
                        (context, index) {
                          int articleIdAtIndex = _articlesId[index];
                          return Dismissible(
                            key: ValueKey(_articlesId[index]),
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
                              setState(() => _articlesId.removeAt(index));
                              SnackBar snackbar = SnackBar(
                                content: const Text('Removed'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() => _articlesId.insert(
                                        index, articleIdAtIndex));
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(snackbar);
                            },
                            child: HandleArticleDisplay(
                                articles: _articlesId, index: index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Colors.blueAccent.shade400,
            selectedItemColor: Colors.yellow,
            unselectedItemColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() => _currentIndex = index);
            },
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
