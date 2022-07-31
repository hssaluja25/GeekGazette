import 'package:flutter/material.dart';
import '../src/article.dart';
import '../services/fetch_article.dart';
import '../services/display_article.dart';

class HandleArticleDisplay extends StatelessWidget {
  const HandleArticleDisplay({
    Key? key,
    required List<int> articles,
    required int index,
  })  : _articles = articles,
        _index = index,
        super(key: key);

  final int _index;
  final List<int> _articles;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article>(
      future: getArticle(_articles[_index]),
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
