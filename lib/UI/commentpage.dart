// TODO First of all make the font look like the font from the catalog app.
// TODO Then make the appBar floating.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../src/comments.dart';
import '../json_parsing.dart';

// Returns Comment object
Future<Comment> getComment(int id) async {
  final myUri =
      Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json');
  final response = await http.get(myUri);
  if (response.statusCode == 200) {
    return fromJson2Comment(response.body);
  } else {
    return const Comment(
      by: '',
      id: 0,
      parent: 0,
      text: 'There was an error making the network call',
      time: 0,
      type: '',
    );
  }
}

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key, required this.commentIds}) : super(key: key);
  final List? commentIds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.yellow[700],
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
                              return ListTile(
                                leading: const Icon(Icons.account_circle_sharp),
                                title: Text('${snapshot.data.text}'),
                                dense: true,
                                onTap: () {},
                              );
                            } else {
                              // The comment was deleted by the user. The else block is necessary otherwise the CircularProgressIndicator is built (as there is no return statement).
                              return Container();
                            }
                          } else if (snapshot.hasError) {
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
