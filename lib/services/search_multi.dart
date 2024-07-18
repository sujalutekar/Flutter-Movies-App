import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/secret_keys.dart';

class SearchMulti with ChangeNotifier {
  final String accessToken = Constants.accessToken;

  List searchResults = [];
  bool isLoading = false;

  Future<void> searchMulti(String query) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/search/multi?query=$query'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      List content = jsonDecode(res.body)['results'];

      searchResults = content;
      notifyListeners();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

      log(e.toString());
    }
  }
}
