import 'package:intl/intl.dart';

String formatDate(int milliseconds) {
  final template = DateFormat('MMM dd');
  return template.format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}
