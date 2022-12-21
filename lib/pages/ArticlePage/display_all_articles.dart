import 'package:flutter/material.dart';
import 'package:hackernews/pages/ArticlePage/Custom%20Widgets/display_article.dart';

import '../../src/article.dart';

/// Accepts a list of [Article]s and returns a list of Widgets
/// Invokes [DisplayArticle] helper function
List<Widget> displayCollectionOfArticles(
    List<Article> articles, BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  List<Widget> result = [];
  for (int i = 0; i < articles.length; i++) {
    result.add(
      Dismissible(
        key: ValueKey(i),
        background: Container(
          color: Colors.yellow,
          child: Padding(
            padding: EdgeInsets.only(left: 0.05089 * width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/trash.gif',
                  height: 0.0479 * height,
                ),
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.yellow,
          child: Padding(
            padding: EdgeInsets.only(right: 0.05089 * width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/icons/trash.gif',
                  height: 0.0479 * height,
                ),
              ],
            ),
          ),
        ),
        child: DisplayArticle(articles[i]),
      ),
    );
  }
  return result;
}
