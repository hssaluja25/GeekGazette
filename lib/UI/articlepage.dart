import 'package:flutter/material.dart';
import '../services/fetchArticle.dart';
import '../services/fetchBestStories.dart';

// Displays top stories
class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<int> _articles = [];

  @override
  void initState() {
    super.initState();
    getBestStories().then((value) => setState(() => _articles = value));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        List<int> tempList = await getBestStories();
        setState(() => _articles = tempList);
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
