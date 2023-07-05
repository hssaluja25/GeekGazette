import 'package:flutter/material.dart';
import 'package:hackernews/pages/error/errorpage.dart';
import '../../services/API/fetch_articles.dart';
import '../../src/article.dart';
import 'Custom Widgets/create_listtile.dart';

class ArticlePage extends StatefulWidget {
  // Has 50 ids corresponding to best stories
  final List<int> articles;
  final Map<String, String> bookmarks;

  const ArticlePage({required this.articles, required this.bookmarks, Key? key})
      : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Stream<Article> generateArticlesStream;
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    generateArticlesStream = generateArticles(articleIds: widget.articles);
  }

  onPress() {
    setState(() {
      widgets = [];
      generateArticlesStream = generateArticles(articleIds: widget.articles);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return StreamBuilder(
      stream: generateArticlesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/images/loading.gif'),
          );
        } else if (snapshot.hasData) {
          Article article = snapshot.data;
          bool isBookmarked =
              widget.bookmarks.containsKey(article.id.toString());
          Dismissible d = Dismissible(
            key: ValueKey(article.id),
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
            child: CreateListtile(
              article: article,
              bookmarks: widget.bookmarks,
              isBookmarked: isBookmarked,
            ),
            onDismissed: (DismissDirection direction) {
              // Store current article in list of dismissed articles
              // st we know not to display it in future
              // NOTE: Bookmarked articles can also be dismissed from
              // article tab but they are stil visible in the bookmarks tab
              List<String> dismissedArticles = [];
              dismissedArticles.add(article.id.toString());
              setState(() {
                widgets.removeAt(widgets.length);
              });
            },
          );

          // I have done this because somehow on changing tabs, the last article is added again leading to duplicates.
          // ! DO CHANGE 20 TO 50.
          widgets.add(d);
          // if (widgets.length <= 19) {
          // ! Change this line too.
          // So that total Widget length is now 20.
          // }
          return ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int index) {
              return widgets[index];
            },
          );
        } else if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return const ErrorPage();
        } else {
          return Center(
            child: Image.asset('assets/images/loading.gif'),
          );
        }
      },
    );
  }
}
