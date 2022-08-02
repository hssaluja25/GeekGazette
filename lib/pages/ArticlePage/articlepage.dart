import 'package:flutter/material.dart';
import 'Custom Widgets/handle_article_display.dart';

class ArticlePage extends StatefulWidget {
  final List<int> articlesId;
  const ArticlePage(this.articlesId, {Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text(
            'Home',
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
            childCount: widget.articlesId.length,
            addAutomaticKeepAlives: true,
            (context, index) {
              int articleIdAtIndex = widget.articlesId[index];
              return Dismissible(
                key: ValueKey(widget.articlesId[index]),
                background: Container(
                  color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/trash.gif',
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/icons/trash.gif',
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  setState(() => widget.articlesId.removeAt(index));
                  SnackBar snackbar = SnackBar(
                    content: const Text('Removed'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() =>
                            widget.articlesId.insert(index, articleIdAtIndex));
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(snackbar);
                },
                child: HandleArticleDisplay(
                    articles: widget.articlesId, index: index),
              );
            },
          ),
        ),
      ],
    );
  }
}
