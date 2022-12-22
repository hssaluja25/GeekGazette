import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

import '../../../services/format_date.dart';
import '../../../src/article.dart';
import '../../CommentsPage/commentpage.dart';

class DisplayArticle extends StatefulWidget {
  final Article article;
  final List<String> bookmarks;
  SharedPreferences prefs;

  /// Allows bookmarking, opening the URL, sharing post and displaying the comments
  DisplayArticle(
      {required this.article,
      required this.prefs,
      required this.bookmarks,
      Key? key})
      : super(key: key);

  @override
  State<DisplayArticle> createState() => _DisplayArticleState();
}

class _DisplayArticleState extends State<DisplayArticle> {
  bool _isBookmarked = false;

  @override
  void initState() {
    _isBookmarked = widget.bookmarks.contains(widget.article.id.toString());
    super.initState();
  }

  /// Triggered when the user presses on the bookmark iconbutton
  /// If previously bookmarked -> now removed.
  /// If not bookmarked previously -> now bookmarked.
  handleBookmarking() async {
    print('Before press, bookmarks = ${widget.bookmarks}');

    if (!_isBookmarked) {
      // Add to bookmark
      widget.bookmarks.add('${widget.article.id}');
      widget.prefs.setStringList('bookmarks', widget.bookmarks.toList());
      if (mounted) {
        setState(() => _isBookmarked = true);
      }
    } else {
      // Remove from bookmarks
      widget.bookmarks.remove('${widget.article.id}');
      widget.prefs.setStringList('bookmarks', widget.bookmarks.toList());
      if (mounted) {
        setState(() => _isBookmarked = false);
      }
    }
    print('After, bookmarks = ${widget.bookmarks}');
  }

  /// When the user presses on the ListTile, the associated URL is opened.
  handleOpeningUrl() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final urlOfArticle = Uri.parse(widget.article.url ?? '');
        if (await canLaunchUrl(urlOfArticle)) {
          launchUrl(urlOfArticle);
        } else {
          print(
              'The URL Launcher cannot launch the URL: ${widget.article.url}.  This happens on post like Ask HN.');
          // We will open the hackernews page so that the user can read the post
          // description too, not just the title
          final hnUrl = Uri.parse(
              'https://news.ycombinator.com/item?id=${widget.article.id}');
          if (await canLaunchUrl(hnUrl)) {
            launchUrl(hnUrl);
          } else {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Cannot open this article'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } on SocketException catch (_) {
      SnackBar snackbar =
          const SnackBar(content: Text('No Internet Connection'));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackbar);
    }
  }

  /// If internet connection is available, the [CommentsPage] is displayed.
  /// Else a SnackBar is displayed with appropriate error message.
  openComments() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                CommentsPage(commentIds: widget.article.kids),
          ),
        );
      }
    } on SocketException catch (_) {
      SnackBar snackbar =
          const SnackBar(content: Text('No Internet Connection'));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.article.by} · ${formatDate(milliseconds: widget.article.time ?? 0)}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(widget.article.title ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: _isBookmarked
                      ? const FaIcon(
                          FontAwesomeIcons.solidBookmark,
                          size: 20,
                          color: Colors.yellow,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.bookmark,
                          size: 20,
                        ),
                  onPressed: handleBookmarking,
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.comment,
                    size: 20,
                  ),
                  onPressed: openComments,
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.shareNodes,
                    size: 20,
                  ),
                  onPressed: () {
                    Share.share(
                      widget.article.url ?? '',
                      subject: 'Check out this article',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        onTap: handleOpeningUrl,
      ),
    );
  }
}
