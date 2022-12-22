// For a first time user, create user id and store it
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random rnd = Random.secure();
String generateState({required int length, required SharedPreferences prefs}) {
  String uid = String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
  prefs.setString('uid', uid);
  return uid;
}
