// TODO Find a library that properly converts JSON text to String. Example ' is converted to &#x27;
// TODO Add refresh indicator and key.
// TODO Add Progress bar indicator to open Webpages OR open in external application I have added a TODO just above it could be added. So search for TODO.
// TODO Not all comments are being displayed for a particular post.
import 'package:flutter/material.dart';
// 👇 Needed to change the status bar color.
import 'package:flutter/services.dart';
import 'UI/articlepage.dart';

void main() {
  runApp(const HackerNews());
}

// Calls the HomePage widget
class HackerNews extends StatelessWidget {
  const HackerNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HackerNews Reader',
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.yellow,
        ),
        child: SafeArea(child: ArticlePage()),
      ),
    );
  }
}
