import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/see_all_page.dart';
import '../pages/tv_show_details_page.dart';
import '../services/fetch_movies.dart';

class TvShowTile extends StatelessWidget {
  final String title;
  final List movies;
  final String url;

  const TvShowTile({
    super.key,
    required this.title,
    required this.movies,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final loadMore = Provider.of<FetchMovies>(context);

    String truncateString(String text, {int wordLimit = 5}) {
      List<String> words = text.split(' ');
      if (words.length <= wordLimit) {
        return text;
      } else {
        return '${words.take(wordLimit).join(' ')}...';
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Colors.grey.shade700,
                  ),
                ),
                onPressed: () {
                  loadMore.loadedMedia = [];
                  loadMore.page = 1;

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SeeAllPage(
                          title: title,
                          movies: movies,
                          movieTitle: 'name',
                          url: url,
                          mediaType: 'tv',
                        );
                      },
                    ),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          // color: Colors.red,
          height: 235,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Map singleTvShow = movies[index];

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return TvShowDetailsPage(
                          tvShow: singleTvShow,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  // color: Colors.grey.shade800,
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}',
                          height: 165,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        truncateString(movies[index]['name']),
                        // title for movies , name for tv shows
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
