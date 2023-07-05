import 'package:flutter/material.dart';
import 'package:hackernews/services/API/fetch_bookmarks.dart';

class InitBookmark with ChangeNotifier {
  Future<Map<String, String>> _initBookmarks = initializeBookmarks();

  Future<Map<String, String>> get initBookmarks => _initBookmarks;

  set initBookmarks(Future<Map<String, String>> value) {
    _initBookmarks = value;
    notifyListeners();
  }
}
