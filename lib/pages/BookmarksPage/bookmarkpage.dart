import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ArticlePage/display_all_articles.dart';

class BookmarkPage extends StatelessWidget {
  List<String> bookmarks;
  SharedPreferences prefs;
  const BookmarkPage({required this.bookmarks, required this.prefs, Key? key})
      : super(key: key);

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
          delegate: SliverChildListDelegate(
            addAutomaticKeepAlives: true,

            /// We pass a list of [Article]s to this helper function
            displayCollectionOfArticles(
              articles: bookmarks,
              context: context,
              bookmarks: bookmarks,
              prefs: prefs,
            ),
          ),
        ),
      ],
    );
  }
}
