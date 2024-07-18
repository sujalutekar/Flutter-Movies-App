import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_pallete.dart';
import '../services/personal_details.dart';
import './movie_details_page.dart';
import './tv_show_details_page.dart';

class PersonDetailPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String id;

  const PersonDetailPage({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.id,
  });

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  bool isExpanded = false;
  int trimWordsCount = 100;

  String truncateString(String text, {int wordLimit = 5}) {
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
    final personalDetails =
        Provider.of<PersonalDetails>(context, listen: false);
    personalDetails.getPersonDetailById(widget.id);
    personalDetails.getPersonDetailByName(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    final personalDetails = Provider.of<PersonalDetails>(context);

    final words = personalDetails.biography.split(' ');
    final displayedText = isExpanded
        ? personalDetails.biography
        : words.take(trimWordsCount).join(' ') +
            (words.length > trimWordsCount ? ' ...' : '');

    return Scaffold(
      backgroundColor: AppPallete.backgruondColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppPallete.backgruondColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: widget.id,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        height: 270,
                        width: 180,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (personalDetails.age.isNotEmpty)
                          Text(
                            'Age: ${personalDetails.age} years',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          )
                        else
                          Text(
                            'Age: Unknown',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (personalDetails.biography.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biography',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayedText,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (words.length > trimWordsCount)
                      InkWell(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'Read less' : 'Read more',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 12),
            if (personalDetails.knownFor.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Known For',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (personalDetails.knownFor.isNotEmpty)
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: personalDetails.knownFor.length,
                  itemBuilder: (context, index) {
                    bool posterPath =
                        personalDetails.knownFor[index]['poster_path'] != null;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          bool isMovie = personalDetails.knownFor[index]
                                  ['media_type'] ==
                              'movie';
                          Map singleMovie = personalDetails.knownFor[index];
                          Map singleTvShow = personalDetails.knownFor[index];

                          if (isMovie) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(
                                movie: singleMovie,
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
                        child: SizedBox(
                          width: 125,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  posterPath
                                      ? 'https://image.tmdb.org/t/p/w500${personalDetails.knownFor[index]['poster_path']}'
                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcxvROcJNSUzCzBx7Bncr5KUkZ_fLmznFf_A&s',
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 120,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                truncateString(
                                  personalDetails.knownFor[index]['title'] ??
                                      personalDetails.knownFor[index]['name'] ??
                                      'Unknown',
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  // fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
