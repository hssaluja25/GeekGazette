// TODO What does else block of getComment and getArticle even do? Check it. I have written comments there.
// TODO We might not need flutter_linkify if we are already using RichText as we can use the recognizer property.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../src/comments.dart';
import '../json_parsing.dart';
import '../services/html_decode.dart';

// Returns Comment object
Future<Comment> getComment(int id) async {
  final myUri =
      Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(myUri);
  if (response.statusCode == 200) {
    return fromJson2Comment(response.body);
  } else {
    // What does this do? Is it even executed? Or snapshot.error is executed?
    throw HttpException('${response.statusCode}');
  }
}

List<TextSpan> styleComment(String input) {
  // This will directly assinged to the children parameter of TextSpan contained within RichText.
  List<TextSpan> childrenList = [];

  var list = input.split("\n");
  for (String line in list) {
    // Style with Courier.
    if (line.startsWith("> ")) {
      childrenList.add(TextSpan(
          text: line + '\n',
          style: TextStyle(
            fontFamily: 'Marvel',
            fontSize: 16,
          )));
    }
    // Style normally.
    else {
      childrenList.add(TextSpan(text: line));
    }
  }
  return childrenList;
}

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
                                leading: const Icon(Icons.account_circle_sharp),
                                title: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'Noticia',
                                        color: Colors.black),
                                    children: styleComment(correctedText),
                                  ),
                                ),
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
