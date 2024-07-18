import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';

import '../constants/app_pallete.dart';
import '../services/fetch_movies.dart';
import '../services/search_multi.dart';
import '../widgets/movie_tile.dart';
import '../widgets/tv_show_tile.dart';
import './movie_details_page.dart';
import './search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late InfiniteScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = InfiniteScrollController();

    final fetchMovies = Provider.of<FetchMovies>(context, listen: false);

    fetchMovies.getPopularMovies();
    fetchMovies.getTrendingMovies();
    fetchMovies.getTrendingTvShows();
    fetchMovies.getUpcomingMovies();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchMovies = Provider.of<FetchMovies>(context);

    return Scaffold(
      backgroundColor: AppPallete.backgruondColor,
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // empty the search results before navigating to the search page
              context.read<SearchMulti>().searchResults = [];

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SearchPage();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: AppPallete.backgruondColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Image Slider
            if (fetchMovies.popularMoviesImages.isNotEmpty)
              SizedBox(
                height: 400,
                child: InfiniteCarousel.builder(
                  itemCount: fetchMovies.popularMoviesImages.length,
                  itemExtent: 225,
                  center: true,
                  velocityFactor: 0.7,
                  controller: controller,
                  axisDirection: Axis.horizontal,
                  loop: true,
                  itemBuilder: (context, itemIndex, realIndex) {
                    Map singleMovie = fetchMovies.popularMovies[itemIndex];

                    return InkWell(
                      onTap: () {
                        log('Tapped on ${fetchMovies.popularMovies[itemIndex]['title']}');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movie: singleMovie),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                                fetchMovies.popularMoviesImages[itemIndex]),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const SizedBox.shrink(),

            const SizedBox(height: 12),

            // upcoming movies
            MovieTile(
              title: 'Upcoming Movies',
              movies: fetchMovies.upcomingMovies,
              url: 'https://api.themoviedb.org/3/movie/upcoming',
            ),

            // trending movies
            MovieTile(
              title: 'Trending Movies',
              movies: fetchMovies.trendingMovies,
              url: 'https://api.themoviedb.org/3/trending/movie/day',
            ),
            const SizedBox(height: 12),

            // tv shows
            TvShowTile(
              title: 'TV Shows',
              movies: fetchMovies.trendingTvShows,
              url: 'https://api.themoviedb.org/3/trending/tv/day',
            ),
          ],
        ),
      ),
    );
  }
}
