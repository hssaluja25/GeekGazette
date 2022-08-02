import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/format_date.dart';
import '../../CommentsPage/commentpage.dart';

class DisplayArticle extends StatefulWidget {
  final AsyncSnapshot snapshot;

  /// Allows for bookmarking, opening the associated URL, sharing the article,
  /// displaying the comments.
  /// Swiping to dismiss is managed by ArticlePage
  const DisplayArticle(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<DisplayArticle> createState() => _DisplayArticleState();
}

class _DisplayArticleState extends State<DisplayArticle> {
  bool _isBookmarked = false;

  /// Triggered when the user presses on the bookmark iconbutton
  /// If previously bookmarked -> now removed.
  /// If not bookmarked previously -> now bookmarked.
  /// Also changes the icon color.
  handleBookmarking() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'bookmarks';
    final bookmarkedArticles = prefs.getStringList(key) ?? [];

    // Add to bookmark, if not bookmarked
    if (!_isBookmarked) {
      // Ensures that the article to bookmark was not already in the list of
      // bookmarked articles.
      if (!bookmarkedArticles.contains('${widget.snapshot.data!.id}')) {
        bookmarkedArticles.add('${widget.snapshot.data!.id}');
        prefs.setStringList(key, bookmarkedArticles);
        if (mounted) {
          setState(() => _isBookmarked = true);
        }
      }
    } else {
      // If bookmarked, remove from bookmarks.
      bookmarkedArticles.remove('${widget.snapshot.data!.id}');
      prefs.setStringList(key, bookmarkedArticles);
      if (mounted) {
        setState(() => _isBookmarked = false);
      }
    }
  }

  /// When the user presses on the ListTile, the associated URL is opened.
  handleOpeningUrl() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      final urlOfArticle = Uri.parse(widget.snapshot.data.url);
      // TODO Come here for adding progress indicator to webview.
      if (await canLaunchUrl(urlOfArticle)) {
        launchUrl(urlOfArticle);
      } else {
        // Display a dialog box saying that the URL could not be launched.
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('There was an error opening the web page'),
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
    } else {
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              CommentsPage(commentIds: widget.snapshot.data.kids),
        ),
      );
    } else {
      SnackBar snackbar =
          const SnackBar(content: Text('No Internet Connection'));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackbar);
    }
  }

  /// Initialize the _isBookmarked instance variable on app (re)start.
  @override
  void initState() {
    () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      const String key = 'bookmarks';
      final List<String> bookmarkedArticles = prefs.getStringList(key) ?? [];
      if (bookmarkedArticles.contains('${widget.snapshot.data!.id}')) {
        if (mounted) {
          setState(() => _isBookmarked = true);
        }
      }
    }();
    super.initState();
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
              '${widget.snapshot.data!.by} · ${formatDate(milliseconds: widget.snapshot.data!.time)}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(widget.snapshot.data!.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: _isBookmarked
                      ? const FaIcon(FontAwesomeIcons.solidBookmark,
                          size: 20, color: Colors.yellow)
                      : const FaIcon(FontAwesomeIcons.bookmark, size: 20),
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
                      widget.snapshot.data!.url,
                      subject: 'Check out this article from Hacker News',
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
