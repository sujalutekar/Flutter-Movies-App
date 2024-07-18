import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_pallete.dart';
import './tv_show_details_page.dart';
import '../pages/movie_details_page.dart';
import '../services/fetch_movies.dart';

class SeeAllPage extends StatefulWidget {
  final String title;
  final List movies;
  final String movieTitle;
  final String url;
  final String mediaType;

  const SeeAllPage({
    super.key,
    required this.title,
    required this.movies,
    required this.movieTitle,
    required this.url,
    required this.mediaType,
  });

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  @override
  void initState() {
    super.initState();
    context.read<FetchMovies>().loadMore(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    final loadMore = Provider.of<FetchMovies>(context, listen: true);
    final loadedMedia = loadMore.loadedMedia;

    return Scaffold(
      backgroundColor: AppPallete.backgruondColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppPallete.backgruondColor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  bool isMovie = widget.mediaType == 'movie';
                  Map singleMovie = loadedMedia[index];
                  Map tvShow = loadedMedia[index];

                  return GestureDetector(
                    onTap: () {
                      if (isMovie) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                            movie: singleMovie,
                          ),
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TvShowDetailsPage(
                            tvShow: tvShow,
                          ),
                        ));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppPallete.cardColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10).copyWith(
                                bottomLeft: const Radius.circular(0),
                                bottomRight: const Radius.circular(0),
                              ),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${loadedMedia[index]['poster_path']}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              loadedMedia[index][widget.movieTitle],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: loadedMedia.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
                .copyWith(bottom: 4),
            sliver: SliverToBoxAdapter(
              child: loadMore.isLoading
                  ? const LinearProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.cardColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {
                        loadMore.page++;
                        loadMore.loadMore(widget.url);
                      },
                      child: const Text(
                        'Load More',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
