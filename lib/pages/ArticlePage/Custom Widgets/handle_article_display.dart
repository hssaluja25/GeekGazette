import 'package:flutter/material.dart';
import '../../../src/article.dart';
import '../../../services/API/fetch_article.dart';
import 'display_article.dart';

class HandleArticleDisplay extends StatelessWidget {
  /// Fetches a particular article.
  /// In case of an error, it displays a Container.
  /// Else, it calls [DisplayArticle]
  const HandleArticleDisplay(
      {Key? key, required this.articles, required this.index})
      : super(key: key);

  final int index;
  final List<int> articles;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article>(
      future: getArticle(articles[index]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.title != null) {
            return DisplayArticle(snapshot);
          } else {
            // The article was deleted
            return Container();
          }
        } else if (snapshot.hasError) {
          // If there is an error getting an inidividual article, it won't be
          // displayed.
          return Container();
        }
        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
