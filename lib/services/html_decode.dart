import 'package:html_unescape/html_unescape.dart';

/// Replaces <p> in the text with \n
String changePara(String input) {
  String find = '<p>';
  String replaceWith = '\n';
  return input.replaceAll(find, replaceWith);
}

/// The comment text is HTML.
/// This function styles the HTML. It uses the html_unescape library to do most
/// of the work (like converting &amp; to &). However, we have to do some manual
/// work too.
String HtmlDecode(String input) {
  var unescape = HtmlUnescape();
  var halfCorrect = unescape.convert(input);
  var changesThePara = changePara(halfCorrect);
  return changesThePara;
}
