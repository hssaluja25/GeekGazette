import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hackernews/providers/fetch_best.dart';
import 'package:hackernews/providers/init_bookmark.dart';
import 'package:hackernews/services/API/fetch_best_stories.dart';
import 'package:hackernews/services/API/fetch_bookmarks.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  refreshPressed() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint("Internet restored 🥰");
        if (!mounted) return;
        Provider.of<InitBookmark>(context, listen: false).initBookmarks =
            initializeBookmarks();
        Provider.of<FetchBest>(context, listen: false).fetchBestFuture =
            fetchBestStories();
      }
    } on SocketException catch (_) {
      // If no internet connection, do nothing.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeff1f3),
      body: Column(
        children: [
          Image.asset('assets/images/error.png'),
          Container(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF94c388),
                foregroundColor: const Color(0xFF474747),
                padding: const EdgeInsets.all(20),
                elevation: 2,
              ),
              onPressed: refreshPressed,
              child: const Text('Refresh'),
            ),
          ),
        ],
      ),
    );
  }
}
