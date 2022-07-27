import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

List<TextSpan> createChildrenListForRichText(
  String input,
  BuildContext context,
) {
  List<TextSpan> childrenList = [];
  var list = input.split("\n");
  for (String line in list) {
    line += '\n';
    if (!line.startsWith("> ")) {
      if (!line.contains('<i>')) {
        if (!line.contains('</a>')) {
          childrenList.add(TextSpan(text: line));
        } else {
          styleHyperLinksOnly(line, childrenList, context);
        }
      } else {
        if (!line.contains('</a>')) {
          styleItalicsOnly(line, childrenList);
        } else {
          styleHyperLinksAndItalics(line, childrenList, context);
        }
      }
    } else {
      if (!line.contains('<i>')) {
        if (!line.contains('</a>')) {
          styleQuotesOnly(line, childrenList);
        } else {
          styleHyperLinksAndQuotes(line, childrenList, context);
        }
      } else {
        if (!line.contains('</a>')) {
          styleItalicsAndQuotes(line, childrenList);
        } else {
          styleItalicsAndQuotesAndHyperlinks(line, childrenList, context);
        }
      }
    }
  }
  return childrenList;
}

void styleQuotesOnly(String line, List<TextSpan> childrenList) {
  childrenList.add(
    TextSpan(
      text: line,
      style: TextStyle(
        fontFamily: 'Marvel',
        fontSize: 16,
      ),
    ),
  );
}

void styleHyperLinksOnly(
    String line, List<TextSpan> childrenList, BuildContext context) {
  // This works even if the link is at the beginning of the comment line.
  int openingTagStartsAt = line.indexOf('<a');
  int openingTagStopsAt = line.indexOf('">');
  int closingTagStartsAt = line.indexOf('</a>');
  int linkStartsAt = line.indexOf('href="');
  int linkStopsAt = line.indexOf('"', linkStartsAt + 6);
  String link = line.substring(linkStartsAt + 6, linkStopsAt);
  Uri linkUri = Uri.parse(link);
  TextSpan ts1 = TextSpan(text: line.substring(0, openingTagStartsAt));
  TextSpan ts2 = TextSpan(
    text: line.substring(openingTagStopsAt + 2, closingTagStartsAt),
    style: TextStyle(color: Colors.blue),
    recognizer: TapGestureRecognizer()
      ..onTap = () async {
        if (await canLaunchUrl(linkUri)) {
          launchUrl(linkUri);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Could not open URL. Ensure your web server is updated.'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      },
  );
  TextSpan ts3 = TextSpan(text: line.substring(closingTagStartsAt + 4));
  childrenList
    ..add(ts1)
    ..add(ts2)
    ..add(ts3);
}

void styleItalicsOnly(String line, List<TextSpan> childrenList) {
  int opening_i_tag = line.indexOf('<i>');
  int closing_i_tag = line.indexOf('</i>');
  TextSpan ts1 = TextSpan(text: line.substring(0, opening_i_tag));
  TextSpan ts2 = TextSpan(
    text: line.substring(opening_i_tag + 3, closing_i_tag),
    style: TextStyle(fontStyle: FontStyle.italic),
  );
  TextSpan ts3 = TextSpan(text: line.substring(closing_i_tag + 4));
  childrenList
    ..add(ts1)
    ..add(ts2)
    ..add(ts3);
}

void applyNoStyling(List childrenList, String line) {
  childrenList.add(TextSpan(text: line));
}

// ! Check this one. Also see copy for the 2 cases within.
// ! Also there can be multiple links and hyperlinks in a single line of comment.
void styleHyperLinksAndItalics(
    String line, List<TextSpan> childrenList, BuildContext context) {
  line = line.replaceAll('<i>', '');
  line = line.replaceAll('</i>', '');

  while (line.contains('</a>')) {
    // ! Replace one by one
    RegExp regex = RegExp(
        r'<a href="https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)" rel="nofollow">');
    String nextMatch = regex.firstMatch(line).toString();
    String link = line.substring(
        line.indexOf(nextMatch) + nextMatch.length, line.indexOf('</a>'));
    line = line.replaceFirst(
        RegExp(
            r'<a href="https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)" rel="nofollow">'),
        '');
    line = line.replaceFirst('</a>', '');
    childrenList
        .add(TextSpan(text: link, style: TextStyle(color: Colors.blue)));
  }
  childrenList.add(TextSpan(text: line));
}

void styleHyperLinksAndQuotes(
    String line, List<TextSpan> childrenList, BuildContext context) {
  childrenList.add(TextSpan(text: line));
}

void styleItalicsAndQuotes(String line, List<TextSpan> childrenList) {
  childrenList.add(TextSpan(text: line));
}

void styleItalicsAndQuotesAndHyperlinks(
    String line, List<TextSpan> childrenList, BuildContext context) {
  childrenList.add(TextSpan(text: line));
}
