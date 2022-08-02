import 'package:intl/intl.dart';

String formatDate({required int milliseconds}) {
  final template = DateFormat('MMM dd');
  return template.format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}
