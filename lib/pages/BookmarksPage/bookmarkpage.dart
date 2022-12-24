import 'package:flutter/material.dart';
import 'dart:convert';
import '../../src/article.dart';
import '../ArticlePage/Custom Widgets/create_listtile.dart';

class BookmarkPage extends StatelessWidget {
  Map<String, String> bookmarks;
  final String uid;
  late List<String> keys;
  BookmarkPage({required this.uid, required this.bookmarks, Key? key})
      : super(key: key) {
    keys = bookmarks.keys.toList();
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
            childCount: bookmarks.length,
            addAutomaticKeepAlives: true,
            (context, index) {
              String key = keys[index];
              Article a = Article.fromJson(jsonDecode(bookmarks[key] ?? ''));
              return CreateListtile(
                article: a,
                bookmarks: bookmarks,
                uid: uid,
                isBookmarked: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
