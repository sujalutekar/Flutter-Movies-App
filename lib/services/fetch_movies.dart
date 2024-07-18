import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/secret_keys.dart';

class FetchMovies with ChangeNotifier {
  final String accessToken = Constants.accessToken;

  List trendingMovies = [];
  List popularMovies = [];
  List<String> popularMoviesImages = [];
  List trendingTvShows = [];
  List upcomingMovies = [];

  // for see all page
  int page = 1;
  List loadedMedia = [];
  bool isLoading = false;

  Future<void> getTrendingMovies() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/trending/movie/day'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );
      List content = jsonDecode(res.body)['results'];

      trendingMovies = content;
      notifyListeners();

      // log(trendingMovies.toString(), name: 'Trending Movies');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getPopularMovies() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/popular'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );
      List content = jsonDecode(res.body)['results'];

      popularMovies = content;
      notifyListeners();
      popularMoviesImages = popularMovies.map((e) {
        return 'https://image.tmdb.org/t/p/w500${e['poster_path']}';
      }).toList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getTrendingTvShows() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/trending/tv/day'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );
      List content = jsonDecode(res.body)['results'];

      trendingTvShows = content;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUpcomingMovies() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/upcoming'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );
      List content = jsonDecode(res.body)['results'];

      upcomingMovies = content;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadMore(String url) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse('$url?page=$page'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );
      List content = jsonDecode(res.body)['results'];

      loadedMedia = [...loadedMedia, ...content];
      notifyListeners();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

      log(e.toString(), error: e, name: 'Load More Error');
    }
  }
}
