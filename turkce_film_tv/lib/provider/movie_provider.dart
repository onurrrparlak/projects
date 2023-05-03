import 'package:flutter/material.dart';
import 'package:turkce_film_tv/models/movie_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  int _selectedMovieIndex = 0;

  List<Movie> get movies => _movies;
  int get selectedMovieIndex => _selectedMovieIndex;

  Future<void> fetchMovies() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('movies').get();
    _movies = snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
    notifyListeners();
  }

  void selectMovie(int index) {
    _selectedMovieIndex = index;
    notifyListeners();
  }
}
