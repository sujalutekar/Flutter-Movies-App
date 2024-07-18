import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/app_pallete.dart';
import '../services/fetch_tv_show_details.dart';
import './person_detail_page.dart';

class TvShowDetailsPage extends StatefulWidget {
  final Map tvShow;

  const TvShowDetailsPage({
    super.key,
    required this.tvShow,
  });

  @override
  State<TvShowDetailsPage> createState() => _TvShowDetailsPageState();
}

class _TvShowDetailsPageState extends State<TvShowDetailsPage> {
  int seasonNumber = 1;

  String formatDate(String dateInput) {
    DateTime dateTime = DateTime.parse(dateInput);
    return DateFormat("d MMM yyyy").format(dateTime);
  }

  String truncateString(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) {
      return text;
    } else {
      return '${words.take(wordLimit).join(' ')}...';
    }
  }

  @override
  void initState() {
    super.initState();
    final fetchTvShowDetails =
        Provider.of<FetchTVShowDetails>(context, listen: false);
    fetchTvShowDetails.getTvShowDetailsById(widget.tvShow);
    fetchTvShowDetails.getTvEpisodesDetails(widget.tvShow, seasonNumber);
    fetchTvShowDetails.getCastDetailsById(widget.tvShow);
  }

  @override
  Widget build(BuildContext context) {
    final fetchTvShowDetails = Provider.of<FetchTVShowDetails>(context);

    double ratingNumber = widget.tvShow['vote_average'].toDouble() / 2;
    String rating = ratingNumber.toStringAsFixed(1);
    bool backdropPath = widget.tvShow['backdrop_path'] != null;
    bool posterPath = widget.tvShow['poster_path'] != null;

    return Scaffold(
      backgroundColor: AppPallete.backgruondColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppPallete.backgruondColor,
        title: Text(
          widget.tvShow['name'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              backdropPath
                  ? 'https://image.tmdb.org/t/p/w500${widget.tvShow['backdrop_path']}'
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
                          ? 'https://image.tmdb.org/t/p/w500${widget.tvShow['poster_path']}'
                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                      height: 200,
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
                        if (widget.tvShow['first_air_date']
                                .toString()
                                .isNotEmpty &&
                            widget.tvShow['first_air_date'] != null)
                          Text(
                            formatDate(widget.tvShow['first_air_date']),
                            style: const TextStyle(color: Colors.grey),
                          )
                        else
                          const Text(
                            'Unknown',
                            style: TextStyle(color: Colors.grey),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          widget.tvShow['name'],
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
                              value:
                                  widget.tvShow['vote_average'].toDouble() / 2,
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
                        Text(
                          fetchTvShowDetails.numberOfSeasons > 1
                              ? '${fetchTvShowDetails.numberOfSeasons} seasons'
                              : '${fetchTvShowDetails.numberOfSeasons} season',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fetchTvShowDetails.genres,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.tvShow['overview'],
                    style: const TextStyle(
                        color: Color.fromARGB(255, 224, 224, 224)),
                  ),
                ],
              ),
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
                itemCount: fetchTvShowDetails.cast.length,
                itemBuilder: (context, index) {
                  bool profilePath =
                      fetchTvShowDetails.cast[index]['profile_path'] != null;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return PersonDetailPage(
                              imageUrl: profilePath
                                  ? 'https://image.tmdb.org/t/p/w500${fetchTvShowDetails.cast[index]['profile_path']}'
                                  : 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
                              name: fetchTvShowDetails.cast[index]['name'],
                              id: fetchTvShowDetails.cast[index]['id']
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
                              tag: fetchTvShowDetails.cast[index]['id']
                                  .toString(),
                              child: Image.network(
                                profilePath
                                    ? 'https://image.tmdb.org/t/p/w500${fetchTvShowDetails.cast[index]['profile_path']}'
                                    : 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fetchTvShowDetails.cast[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            truncateString(
                                fetchTvShowDetails.cast[index]['character'], 3),
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

            const SizedBox(height: 12),

            // season tiles

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  .copyWith(top: 0),
              child: const Text(
                'Seasons',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fetchTvShowDetails.numberOfSeasons == 0
                    ? 0
                    : fetchTvShowDetails.numberOfSeasons,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        seasonNumber = index + 1;
                      });
                      await fetchTvShowDetails.getTvEpisodesDetails(
                          widget.tvShow, seasonNumber);
                      log('Season ${index + 1}', name: 'Season');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: seasonNumber == (index + 1)
                            ? Colors.blue.shade900
                            : Colors.grey.shade800,
                      ),
                      child: Text(
                        'Season ${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            // episodes per season
            if (fetchTvShowDetails.episodes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No Data Available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fetchTvShowDetails.episodes.length,
                itemBuilder: (context, index) {
                  bool stillPath =
                      fetchTvShowDetails.episodes[index]['still_path'] != null;

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade800,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            stillPath
                                ? 'https://image.tmdb.org/t/p/w500${fetchTvShowDetails.episodes[index]['still_path']}'
                                : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${fetchTvShowDetails.episodes[index]['episode_number']} - ${fetchTvShowDetails.episodes[index]['name']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      '${fetchTvShowDetails.episodes[index]['runtime']} Min',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                truncateString(
                                    '${fetchTvShowDetails.episodes[index]['overview']}',
                                    10),
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
