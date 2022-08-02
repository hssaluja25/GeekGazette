import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ArticlePage/Custom Widgets/handle_article_display.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<int> _bookmarksId = [];

  /// Initialize _bookmarksId from memory
  @override
  void initState() {
    () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      const String key = 'bookmarks';
      // Shared Preferences stores a StringList, so we convert it to List<int>
      final List<String> bookmarkedArticles = prefs.getStringList(key) ?? [];
      List<int> bookmarksId = bookmarkedArticles.map(int.parse).toList();
      if (mounted) {
        setState(() => _bookmarksId = bookmarksId);
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text(
            'Bookmarks',
            style: TextStyle(
              fontFamily: 'Corben',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          floating: true,
          backgroundColor: Colors.yellow,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            addAutomaticKeepAlives: true,
            childCount: _bookmarksId.length,
            (BuildContext context, int index) =>
                HandleArticleDisplay(articles: _bookmarksId, index: index),
          ),
        ),
      ],
    );
  }
}
