import 'package:flutter/material.dart';

import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../pages/person_detail_page.dart';
import '../constants/app_pallete.dart';
import '../services/fetch_movie_details.dart';

class MovieDetailsPage extends StatefulWidget {
  final Map movie;

  const MovieDetailsPage({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  String truncateString(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) {
      return text;
    } else {
      return '${words.take(wordLimit).join(' ')}...';
    }
  }

  String formatDate(String dateInput) {
    DateTime dateTime = DateTime.parse(dateInput);
    return DateFormat("d MMM yyyy").format(dateTime);
  }

  @override
  void initState() {
    final fetchMovieDetails =
        Provider.of<FetchMovieDetails>(context, listen: false);
    fetchMovieDetails.getMovieDetailsById(widget.movie);
    fetchMovieDetails.getCastDetailsById(widget.movie);
    fetchMovieDetails.getMovieReviewsById(widget.movie);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fetchMovieDetails = Provider.of<FetchMovieDetails>(context);

    double ratingNumber = widget.movie['vote_average'].toDouble() / 2 ?? 0;
    String rating = ratingNumber.toStringAsFixed(1);
    bool backdropPath = widget.movie['backdrop_path'] != null;
    bool posterPath = widget.movie['poster_path'] != null;

    return Scaffold(
      backgroundColor: AppPallete.backgruondColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppPallete.backgruondColor,
        title: Text(
          widget.movie['title'] ?? 'Unknown',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              backdropPath
                  ? 'https://image.tmdb.org/t/p/w500${widget.movie['backdrop_path']}'
                  : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                          .copyWith(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      posterPath
                          ? 'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}'
                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                      height: 220,
                      width: 145,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8).copyWith(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.movie['release_date']
                                .toString()
                                .isNotEmpty &&
                            widget.movie['release_date'] != null)
                          Text(
                            formatDate(widget.movie['release_date']),
                            style: const TextStyle(color: Colors.grey),
                          )
                        else
                          const Text(
                            'Unknown',
                            style: TextStyle(color: Colors.grey),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          widget.movie['title'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingStars(
                              valueLabelVisibility: false,
                              value: ratingNumber,
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                size: 18,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 25,
                              maxValue: 5,
                              starSpacing: 4,
                              starOffColor: const Color(0xffe7e8ea),
                              starColor: Colors.amber,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        fetchMovieDetails.movieRuntime != '0'
                            ? Text(
                                '${fetchMovieDetails.movieRuntime} minutes',
                                style: const TextStyle(color: Colors.grey),
                              )
                            : const Text(
                                'Unknown',
                                style: TextStyle(color: Colors.grey),
                              ),
                        const SizedBox(height: 8),
                        Text(
                          fetchMovieDetails.genres,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Cast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // cast details
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fetchMovieDetails.cast.length,
                itemBuilder: (context, index) {
                  bool profilePath =
                      fetchMovieDetails.cast[index]['profile_path'] != null;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return PersonDetailPage(
                              imageUrl: profilePath
                                  ? 'https://image.tmdb.org/t/p/w500${fetchMovieDetails.cast[index]['profile_path']}'
                                  : 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
                              name: fetchMovieDetails.cast[index]['name'],
                              id: fetchMovieDetails.cast[index]['id']
                                  .toString(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 125,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Hero(
                              tag: fetchMovieDetails.cast[index]['id']
                                  .toString(),
                              child: Image.network(
                                profilePath
                                    ? 'https://image.tmdb.org/t/p/w500${fetchMovieDetails.cast[index]['profile_path']}'
                                    : 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fetchMovieDetails.cast[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            truncateString(
                                fetchMovieDetails.cast[index]['character'], 4),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie['overview'].toString().isEmpty
                        ? 'No overview available'
                        : widget.movie['overview'],
                    style: const TextStyle(
                        color: Color.fromARGB(255, 224, 224, 224)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (fetchMovieDetails.reviews.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: fetchMovieDetails.reviews.length,
                      itemBuilder: (context, index) {
                        bool avatarPath = fetchMovieDetails.reviews[index]
                                ['author_details']['avatar_path'] !=
                            null;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 48, 47, 47),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      avatarPath
                                          ? 'https://image.tmdb.org/t/p/w500${fetchMovieDetails.reviews[index]['author_details']['avatar_path']}'
                                          : 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    fetchMovieDetails.reviews[index]['author'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                truncateString(
                                    fetchMovieDetails.reviews[index]['content'],
                                    36),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 224, 224, 224),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    const Text(
                      'No reviews available',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
