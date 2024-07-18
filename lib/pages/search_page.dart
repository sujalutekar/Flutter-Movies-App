// import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:movies/constants/app_pallete.dart';
import 'package:movies/services/search_multi.dart';
import 'package:provider/provider.dart';

// import '../constants/secret_keys.dart';
import 'movie_details_page.dart';
import './person_detail_page.dart';
import './tv_show_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  // List searchResults = [];
  // bool _isLoading = false;
  final TextEditingController searchController = TextEditingController();

  String truncateString(String text, {int wordLimit = 12}) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) {
      return text;
    } else {
      return '${words.take(wordLimit).join(' ')}...';
    }
  }

  // Future<void> searchMulti(String query) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final res = await http.get(
  //       Uri.parse('https://api.themoviedb.org/3/search/multi?query=$query'),
  //       headers: {
  //         'Authorization': 'Bearer ${Constants.accessToken}',
  //         'accept': 'application/json',
  //       },
  //     );

  //     List content = jsonDecode(res.body)['results'];
  //     // log(content.toString(), name: 'Search Results');

  //     setState(() {
  //       searchResults = content;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     log(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final searchMulti = Provider.of<SearchMulti>(context);

    return Scaffold(
      backgroundColor: AppPallete.backgruondColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                style: TextStyle(
                  color: Colors.grey.shade400,
                ),
                onSubmitted: (value) {
                  searchMulti.searchMulti(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for movies, TV shows, and more...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: searchMulti.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : searchMulti.searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            'Search not found!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchMulti.searchResults.length,
                          itemBuilder: (context, index) {
                            bool posterPath = searchMulti.searchResults[index]
                                    ['poster_path'] !=
                                null;
                            bool isMovie = searchMulti.searchResults[index]
                                    ['media_type'] ==
                                'movie';
                            bool isPerson = searchMulti.searchResults[index]
                                    ['media_type'] ==
                                'person';
                            Map singleMovie = searchMulti.searchResults[index];
                            Map singleTvShow = searchMulti.searchResults[index];

                            return InkWell(
                              onTap: () {
                                if (isMovie) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailsPage(
                                      movie: singleMovie,
                                    ),
                                  ));
                                } else if (isPerson) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PersonDetailPage(
                                      id: searchMulti.searchResults[index]['id']
                                          .toString(),
                                      name: searchMulti.searchResults[index]
                                          ['name'],
                                      imageUrl: searchMulti.searchResults[index]
                                                  ['profile_path'] !=
                                              null
                                          ? 'https://image.tmdb.org/t/p/w500${searchMulti.searchResults[index]['profile_path']}'
                                          : 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
                                    ),
                                  ));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TvShowDetailsPage(
                                      tvShow: singleTvShow,
                                    ),
                                  ));
                                }
                              },
                              child: Container(
                                height: 130,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
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
                                        posterPath
                                            ? 'https://image.tmdb.org/t/p/w500${searchMulti.searchResults[index]['poster_path']}'
                                            : isPerson
                                                ? 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg'
                                                : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${searchMulti.searchResults[index]['title'] ?? searchMulti.searchResults[index]['name'] ?? 'Unknown'}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            searchMulti.searchResults[index]
                                                        ['overview'] !=
                                                    null
                                                ? truncateString(
                                                    '${searchMulti.searchResults[index]['overview']}')
                                                : 'No overview available',
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
