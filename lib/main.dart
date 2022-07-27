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
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: SafeArea(child: ArticlePage()),
      ),
    );
  }
}
