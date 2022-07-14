import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.yellow,
        ),
        child: SafeArea(child: MyHomePage(title: 'Hacker News')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.yellow[700],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _articles.removeAt(0);
          });
        },
        child: ListView(
          // _buildItem will take an Article object and do things with it such as styling.
          children: _articles.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.text),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.text,
          style: const TextStyle(fontSize: 34),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${article.commentsCount} comments'),
              IconButton(
                icon: const Icon(Icons.launch),
                onPressed: () async {
                  final tempUrl = Uri(
                    scheme: 'https',
                    host: 'dart.dev',
                    path: 'guides/libraries/library-tour',
                    fragment: 'numbers',
                  );
                  if (await canLaunchUrl(tempUrl)) launchUrl(tempUrl);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
