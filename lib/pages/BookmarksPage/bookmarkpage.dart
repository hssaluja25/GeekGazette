import 'package:flutter/material.dart';
import 'dart:convert';
import '../../src/article.dart';
import '../ArticlePage/Custom Widgets/create_listtile.dart';

class BookmarkPage extends StatelessWidget {
  Map<String, String> bookmarks;
  late List<String> keys;
  BookmarkPage({required this.bookmarks, Key? key}) : super(key: key) {
    keys = bookmarks.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: bookmarks.length,
      itemBuilder: (BuildContext context, int index) {
        String key = keys[index];
        Article a = Article.fromJson(jsonDecode(bookmarks[key] ?? ''));
        return CreateListtile(
          article: a,
          bookmarks: bookmarks,
          isBookmarked: true,
        );
      },
    );
  }
}
