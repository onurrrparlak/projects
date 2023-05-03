import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/models/movie_models.dart';
import 'package:turkce_film_tv/provider/movie_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int selectedMovieIndex = 0;

    final movieProvider = Provider.of<MovieProvider>(context);
    final selectedMovie = movieProvider.movies[selectedMovieIndex];
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(selectedMovie.backgroundImageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Movies',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Consumer<MovieProvider>(
                  builder: (context, movieProvider, child) {
                    return ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: movieProvider.movies.length,
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final movie = movieProvider.movies[index];
                        return GestureDetector(
                          onTap: () {
                            movieProvider.selectMovie(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.5,
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: 6 / 3,
                              child: Image.network(
                                movie.posterImageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
