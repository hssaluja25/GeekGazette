// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

/// Receives ```correctedText``` (with HTML decoded) and styles it.
///
/// Example:
/// + It applies different styles to quoted text.
/// + It italicizes text enclosed within the &lt;i&gt; tags.
List<TextSpan> styleComment(String input, BuildContext context) {
  // This will directly assinged to the children
  // parameter of TextSpan contained within RichText.
  List<TextSpan> childrenList = [];

  // This swallows the newline character in between new lines. Hence we have
  // added a newline after every new line ourselves.
  var list = input.split("\n");
  for (String line in list) {
    line += '\n';
    if (line.startsWith("> ")) {
      childrenList.add(
        TextSpan(
          text: line,
          style: TextStyle(
            fontFamily: 'Marvel',
            fontSize: 16,
          ),
        ),
      );
    } else {
      if (!line.contains('<i>')) {
        if (!line.contains('</a>')) {
          childrenList.add(TextSpan(text: line));
        }
      } else {
        // This would work even if <i> tag is at the beginning of the line.
        int indexOfOpeningTag = line.indexOf('<i>');
        int indexOfClosingTag = line.indexOf('</i>');
        TextSpan normalStylingAtTheStart =
            TextSpan(text: line.substring(0, indexOfOpeningTag));
        TextSpan italicizedText = TextSpan(
          text: line.substring(indexOfOpeningTag + 3, indexOfClosingTag),
          style: TextStyle(fontStyle: FontStyle.italic),
        );
        TextSpan normalStylingAtTheEnd =
            TextSpan(text: line.substring(indexOfClosingTag + 4));
        childrenList
          ..add(normalStylingAtTheStart)
          ..add(italicizedText)
          ..add(normalStylingAtTheEnd);
      }
    }
  }
  return childrenList;
}


// * Code for styling hyperlinks.
// else {
        //   // ! What if there are multiple <a> tags in a single line?
        //   int openingTagStartsAt = line.indexOf('<a');
        //   int openingTagStopsAt = line.indexOf('">');
        //   int closingTagStartsAt = line.indexOf('</a>');
        //   int urlStartsAt = line.indexOf('href="') + 6;
        //   int urlEndsAt = line.indexOf('"', urlStartsAt);
        //   String URL = line.substring(urlStartsAt, urlEndsAt);
        //   Uri URI = Uri.parse(URL);
        //   childrenList
        //     ..add(TextSpan(text: line.substring(0, openingTagStartsAt)))
        //     ..add(TextSpan(
        //       text: line.substring(openingTagStopsAt + 2, closingTagStartsAt),
        //       style: TextStyle(color: Colors.blue),
        //       recognizer: TapGestureRecognizer()
        //         ..onTap = () async {
        //           if (await canLaunchUrl(URI)) {
        //             launchUrl(URI);
        //           } else {
        //             showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return AlertDialog(
        //                   title: Text('Error'),
        //                   content: Text('Could not open URL'),
        //                   actions: [
        //                     TextButton(
        //                       child: const Text('Ok'),
        //                       onPressed: () {
        //                         Navigator.pop(context);
        //                       },
        //                     )
        //                   ],
        //                 );
        //               },
        //             );
        //           }
        //         },
        //     ))
        //     ..add(TextSpan(text: line.substring(closingTagStartsAt + 4)));
        // }