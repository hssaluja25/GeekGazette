import 'package:flutter/material.dart';
import '../services/getTheArticle.dart';

// Displays top stories
class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final List<int> _articles = [
    32107434,
    32106126,
    32106762,
    32080184,
    32087557,
    32104609,
    32106063,
    32104764,
    32117771,
    32120230,
    32093452,
    32105616,
    32126089,
    32115059,
    32110573,
    32126597,
    32094142,
    32106380,
    32101729,
    32110993,
    32094469,
    32120247,
    32105129,
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text(
                'Top Stories',
                style: TextStyle(
                  fontFamily: 'Corben',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.yellow,
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _articles.length,
                addAutomaticKeepAlives: true,
                (context, index) {
                  int articleIdAtIndex = _articles[index];
                  return Dismissible(
                    key: ValueKey(_articles[index]),
                    background: Container(color: Colors.yellow),
                    onDismissed: (DismissDirection direction) {
                      setState(() => _articles.removeAt(index));
                      SnackBar snackbar = SnackBar(
                        content: const Text('Removed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() =>
                                _articles.insert(index, articleIdAtIndex));
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackbar);
                    },
                    child: displayArticle(_articles, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
