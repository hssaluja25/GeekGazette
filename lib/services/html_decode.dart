// TODO Quotes should be displayed in a different style (in Courier; you don't have to import Courier.)
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:html_unescape/html_unescape.dart';

/// Replaces <p> in the text with \n
String changePara(String input) {
  String find = '<p>';
  String replaceWith = '\n';
  return input.replaceAll(find, replaceWith);
}

/// The response from the API can contain HTML code in it. This function converts it into a human-readable string. It uses the html_unescape library to do most of the work (like converting &amp; to &). However, such as for changing paras, we have to do some manual work too.
String HtmlDecode(String input) {
  var unescape = HtmlUnescape();
  var halfCorrect = unescape.convert(input);
  var changesThePara = changePara(halfCorrect);
  return changesThePara;
}