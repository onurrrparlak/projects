
import 'package:flutter/material.dart';
import 'package:gibireplikleri/core/replikler.dart';

var dataList = Replikler.replikler;

String getValueById(int id) {
  final map = dataList.firstWhere((element) => element['id'] == id,
      orElse: () => {'id': -1, 'replik': 'Value not found'});
  return map['replik'];
}

// Create a function to show the Snackbar
void showRandomSnackbar(BuildContext context, int randomIndex) {
  final id = dataList[randomIndex]['id'];
  final value = getValueById(id);
  final snackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    content: Text(
      'Oynatılıyor: $value',
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: const Color(0xFF1d1c21),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

void stopRandomSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
