import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/html_decode.dart';
import '../services/displayComment.dart';
import '../services/betterCommentStyling.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key, required this.commentIds}) : super(key: key);
  final List? commentIds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          'Comments',
          style: TextStyle(
            fontFamily: 'Corben',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: commentIds == null || commentIds == []
          ? const Center(
              child: Text(
              'There are no comments on this post.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
          : ListView(
              addAutomaticKeepAlives: false,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              children: commentIds!
                  .map(
                    (id) => FutureBuilder(
                        future: getComment(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            // Comment was probably deleted if the comment's text returns null
                            if (snapshot.data.text != null) {
                              var correctedText =
                                  HtmlDecode(snapshot.data.text);
                              return ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Noticia',
                                      color: Colors.black,
                                    ),
                                    children: createChildrenListForRichText(
                                        correctedText, context),
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data.by,
                                  textAlign: TextAlign.right,
                                ),
                                leading: FaIcon(FontAwesomeIcons.comment),
                                dense: true,
                                onTap: () {},
                              );
                            } else {
                              // The comment was deleted by the user. The else block is necessary otherwise the CircularProgressIndicator is built (as there is no return statement).
                              return Container();
                            }
                          } else if (snapshot.hasError) {
                            // I think this is executed when the status code is not 200 instead of what I have written in the else block of getArticle.
                            if (snapshot.error
                                    .toString()
                                    .contains('SocketException') &&
                                snapshot.error
                                    .toString()
                                    .contains('errno = 11001')) {
                              return const ListTile(
                                title: Text('No internet connection'),
                              );
                            }
                            // For other errors
                            return ListTile(
                              title: Text('${snapshot.error}'),
                              onTap: () {},
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  )
                  .toList(),
            ),
    );
  }
}
