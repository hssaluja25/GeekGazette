import 'package:flutter/material.dart';
// 👇 Needed to change the status bar color.
import 'package:flutter/services.dart';
import 'pages/ArticlePage/articlepage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'pages/BookmarksPage/bookmarkpage.dart';
import '../../services/API/fetch_best_stories.dart';

void main() {
  runApp(const HackerNews());
}

class HackerNews extends StatefulWidget {
  /// Fetches the best stories and passes it to the ArticlesPage to display them.
  /// Displays an error image when there was an error fetching the best stories.
  /// Handles refreshing to retry again or to update the best stories.
  /// Refreshing also works on the bookmarks tab.
  const HackerNews({Key? key}) : super(key: key);

  @override
  State<HackerNews> createState() => _HackerNewsState();
}

class _HackerNewsState extends State<HackerNews> {
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
    return MaterialApp(
      title: 'HackerNews Reader',
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.yellow),
        child: SafeArea(
          child: !_successFetchingStories
              ? RefreshIndicator(
                  onRefresh: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
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
                    backgroundColor: Colors.white,
                    body: ListView(children: [
                      Image.asset('assets/images/error.jpg'),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Try:',
                              style: TextStyle(fontFamily: 'Noticia'),
                            ),
                            Text(
                              '\u2022 Checking your connection',
                              style: TextStyle(fontFamily: 'Noticia'),
                            ),
                            Text(
                              '\u2022 Checking the proxy and firewall.',
                              style: TextStyle(fontFamily: 'Noticia'),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
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
                        : ArticlePage(_articlesId),
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
                ),
        ),
      ),
    );
  }
}
