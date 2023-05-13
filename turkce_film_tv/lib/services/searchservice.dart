import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/movie_models.dart';

class SearchService {
  static Future<List<Movie>> searchMovies(String searchTerm) async {
    final lowercaseSearchTerm = searchTerm.toLowerCase();

    final snapshot =
        await FirebaseFirestore.instance.collection('movies').get();

    final movies = snapshot.docs
        .map((doc) => Movie.fromJson(doc.data()))
        .where(
            (movie) => movie.title.toLowerCase().contains(lowercaseSearchTerm))
        .toList();

    return movies;
  }
}
