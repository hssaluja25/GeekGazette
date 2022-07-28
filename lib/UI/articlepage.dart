import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../services/fetchArticle.dart';
import '../services/fetchBestStories.dart';

// Displays top stories
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
                  (context, index) {
                    int articleIdAtIndex = _articles[index];
                    return Dismissible(
                      key: ValueKey(_articles[index]),
                      background: Container(color: Colors.yellow),
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
                      child: displayArticle(_articles, index),
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
}
