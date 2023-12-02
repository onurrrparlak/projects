import 'package:flutter/material.dart';

class ProfanityProvider with ChangeNotifier {
  bool _showAll = false;

  bool get showAll => _showAll;

  void toggleShowAll() {
    _showAll = !_showAll;
    notifyListeners();
  }
}
