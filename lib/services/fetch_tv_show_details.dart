import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../constants/secret_keys.dart';

class FetchTVShowDetails with ChangeNotifier {
  final String accessToken = Constants.accessToken;

  String genres = '';
  int numberOfSeasons = 0;
  List episodes = [];
  List cast = [];

  Future<void> getTvShowDetailsById(Map tvShow) async {
    try {
      log(tvShow['id'].toString(), name: 'tvShowId');
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/tv/${tvShow['id']}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      String allGenres = resBody['genres'].map((e) => e['name']).join(' • ');
      int seasons = resBody['number_of_seasons'];

      genres = allGenres;
      notifyListeners();
      numberOfSeasons = seasons;
      notifyListeners();
    } catch (e) {
      log(e.toString(), error: e);
    }
  }

  Future<void> getTvEpisodesDetails(Map tvShow, int seasonNumber) async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/tv/${tvShow['id']}/season/$seasonNumber'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      episodes = resBody['episodes'];
      notifyListeners();
    } catch (e) {
      log(e.toString(), error: e);
    }
  }

  Future<void> getCastDetailsById(Map tvShow) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/tv/${tvShow['id']}/credits'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      cast = resBody['cast'];
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
