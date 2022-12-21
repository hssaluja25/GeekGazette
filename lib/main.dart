import 'package:flutter/material.dart';
// 👇 Needed to change the status bar color.
import 'package:flutter/services.dart';
import 'package:hackernews/pages/error/errorpage.dart';
import 'pages/ArticlePage/articlepage.dart';
import '../../services/API/fetch_best_stories.dart';
import 'dart:io';

void main() {
  runApp(
    const MaterialApp(
      title: 'Reader',
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: Colors.black),
        child: SafeArea(child: HackerNews()),
      ),
    ),
  );
}

class HackerNews extends StatefulWidget {
  const HackerNews({Key? key}) : super(key: key);

  @override
  State<HackerNews> createState() => _HackerNewsState();
}

class _HackerNewsState extends State<HackerNews> {
  // To handle tab change
  int _currentTab = 0;

  /// Fetches id of best stories and passes them to the ```ArticlesPage```
  Future<List<int>> fetchBestStoriesFuture = getBestStories();

  // This function defines what to do when user presses the Refresh button.
  onPress() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          fetchBestStoriesFuture = getBestStories();
        });
      }
    } on SocketException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: fetchBestStoriesFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: _currentTab,
              children: [
                ArticlePage(snapshot.data),
                Container(),
              ],
            ),
            // body: _currentTab == 1 ? Container() : ArticlePage(snapshot.data),
            bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: false,
              showSelectedLabels: false,
              backgroundColor: Colors.blueAccent.shade400,
              selectedItemColor: Colors.yellow,
              unselectedItemColor: Colors.white,
              currentIndex: _currentTab,
              onTap: (int index) {
                setState(() => _currentTab = index);
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
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          print(snapshot.error);
          return ErrorPage(height: height, onPress: onPress);
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset('assets/images/loading.gif'),
            ),
          );
        }
      },
    );
  }
}
