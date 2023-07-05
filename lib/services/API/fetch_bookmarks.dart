import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

// This function can either return a Future or null.
// That is why I have not provided a return type.
// But will it even work?
// If it does, the reason i am doing this is because
// in case of error when i throw an exception in the catch block, the bookmark
// provider is not able to handle it as there can be no try catch in the
// initializer of initBookmarks.
Future<Map<String, String>> initializeBookmarks() async {
  // For now, we are using uid but later we would ask the user to log in.
  // Then using the uid, we would access Firestore.

  // Done to check whether the W/Firestore error i am getting is due to initialization of Firebase or due to my bookmarks future not being able to handle no internet connection
  try {
    final result = await InternetAddress.lookup('example.com')
        .timeout(const Duration(seconds: 2));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc('71XZLVMJPK7MbKPh5Ipz');
      print('Here');
      // Error due to this 👇👇👇👇👇
      final snapshot = await user.get(); //👈👈👈👈👈👈
      // 👆👆👆👆👆👆👆👆👆👆👆👆👆
      final Map<String, String> bookmarks =
          Map<String, String>.from(snapshot.data() ?? <String, String>{});
      return bookmarks;
    } else {
      throw const SocketException('No internet connection');
    }
  } on SocketException catch (_) {
    print("Inside catch block");
    throw const SocketException('Check your internet connection');
  }
}
