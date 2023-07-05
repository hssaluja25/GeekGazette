import 'package:flutter/material.dart';
import 'package:hackernews/services/API/fetch_best_stories.dart';

// The video said no use of mixin for FutureProvider because FutureProvider doesn't update the UI. But i want to update the UI
class FetchBest with ChangeNotifier {
  Future<List<int>> _fetchBestFuture = fetchBestStories();

  Future<List<int>> get fetchBestFuture => _fetchBestFuture;

  set fetchBestFuture(Future<List<int>> value) {
    _fetchBestFuture = value;
    notifyListeners();
  }
}
