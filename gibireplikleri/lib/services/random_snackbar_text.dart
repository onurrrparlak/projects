
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
     margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.07,),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    content: Text(
      'Oynatılıyor: $value',
      style: const TextStyle(
        color: Color(0xFF1d1c21),
      ),
    ),
    backgroundColor: const Color(0XFFecebd4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

void stopRandomSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
