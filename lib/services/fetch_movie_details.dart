import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../constants/secret_keys.dart';

class FetchMovieDetails with ChangeNotifier {
  final String accessToken = Constants.accessToken;

  String movieRuntime = '';
  String genres = '';
  List cast = [];
  List reviews = [];

  Future<void> getMovieDetailsById(Map movie) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/${movie['id']}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);
      String content = resBody['runtime'].toString();
      String allGenres = resBody['genres'].map((e) => e['name']).join(' • ');

      movieRuntime = content;
      notifyListeners();
      genres = allGenres;
      notifyListeners();
    } catch (e) {
      log(e.toString(), error: e, name: 'Movie Details Error');
    }
  }

  Future<void> getCastDetailsById(Map movie) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/${movie['id']}/credits'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      cast = resBody['cast'];
      notifyListeners();
    } catch (e) {
      log(e.toString(), error: e, name: 'Cast Details Error');
    }
  }

  Future<void> getMovieReviewsById(Map movie) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/${movie['id']}/reviews'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      reviews = resBody['results'];
      notifyListeners();
    } catch (e) {
      log(e.toString(), error: e, name: 'Cast Details Error');
    }
  }
}
