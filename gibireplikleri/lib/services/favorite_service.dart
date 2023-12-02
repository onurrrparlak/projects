import 'package:hive/hive.dart';

import '../models/favorites_model.dart';

class FavoritesService {
  final Box<Favorite> _favoritesBox = Hive.box('favorites');

  void addToFavorites(Favorite favorite) {
    _favoritesBox.put(favorite.title, favorite);
  }

  List<Favorite> getFavorites() {
    return _favoritesBox.values.toList();
  }

  void removeFromFavorites(Favorite favorite) {
    _favoritesBox.delete(favorite.title);
  }

  bool isFavorite(Favorite favorite) {
    return _favoritesBox.containsKey(favorite.title);
  }
}
