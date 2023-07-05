import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackernews/pages/BookmarksPage/bookmarkpage.dart';
import 'package:hackernews/pages/error/errorpage.dart';
import 'package:hackernews/providers/fetch_best.dart';
import 'package:hackernews/providers/init_bookmark.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/ArticlePage/articlepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InitBookmark()),
        ChangeNotifierProvider(create: (context) => FetchBest()),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Reader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const SafeArea(
          child: HackerNews(),
        ),
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
  // Fetches id of best stories
  late Future<List<int>> fetchBestStoriesFuture;
  // Fetches bookmarks from Firestore
  late Future<Map<String, String>> fetchBookmarks;
  int currentTab = 0;

  @override
  void didChangeDependencies() {
    debugPrint('Inside didChangeDependencies');
    super.didChangeDependencies();
    fetchBookmarks = Provider.of<InitBookmark>(context).initBookmarks;
    fetchBestStoriesFuture = Provider.of<FetchBest>(context).fetchBestFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchBookmarks,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset('assets/images/loading.gif'),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            debugPrint('Error while fetching bookmarks👉 ${snapshot.error}');
            return const ErrorPage();
          } else if (snapshot.hasData) {
            debugPrint('Fetched bookmarks successfully 😎');
            Map<String, String> bookmarks = snapshot.data ?? {};
            return FutureBuilder(
              future: fetchBestStoriesFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                      child: Image.asset('assets/images/loading.gif'),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    debugPrint(
                        'Error while fetching ids of best stories👉 ${snapshot.error}');
                    return const ErrorPage();
                  } else if (snapshot.hasData) {
                    debugPrint('Fetched ids of best stories 😎');
                    List<int> bestStories = snapshot.data;
                    return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        title: Text(
                          currentTab == 0 ? 'Home' : 'Bookmarks',
                          style: const TextStyle(
                            fontFamily: 'Corben',
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Colors.yellow,
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                        showUnselectedLabels: false,
                        showSelectedLabels: false,
                        backgroundColor: Colors.blueAccent.shade400,
                        selectedItemColor: Colors.yellow,
                        unselectedItemColor: Colors.white,
                        currentIndex: currentTab,
                        onTap: (int index) {
                          setState(() {
                            currentTab = index;
                          });
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
                      body: IndexedStack(
                        index: currentTab,
                        children: [
                          ArticlePage(
                            articles: bestStories,
                            bookmarks: bookmarks,
                          ),
                          BookmarkPage(
                            bookmarks: bookmarks,
                          ),
                        ],
                      ),
                    );
                  }
                }
                // When snapshot.connectionState == ConnectionState.none
                // i.e., when future is null
                // Show error then
                debugPrint('Error while fetching ids of best stories');
                debugPrint(
                    'fetchBestStoriesFuture is null. This should never happen.');
                return const ErrorPage();
              },
            );
          }
        }
        // When snapshot.connectionState == ConnectionState.none
        // This should never happen
        debugPrint('fetchBookmarks future is null');
        debugPrint('This should have never happened');
        return const ErrorPage();
      },
    );
  }
}
