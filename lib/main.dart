import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/home_page.dart';
import './services/fetch_movies.dart';
import './services/fetch_movie_details.dart';
import './services/personal_details.dart';
import './services/fetch_tv_show_details.dart';
import './services/search_multi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FetchMovies(),
        ),
        ChangeNotifierProvider(
          create: (context) => FetchMovieDetails(),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonalDetails(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchMulti(),
        ),
        ChangeNotifierProvider(
          create: (context) => FetchTVShowDetails(),
        ),
      ],
      child: MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );
  }
}
