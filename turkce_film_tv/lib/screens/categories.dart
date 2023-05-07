import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<DocumentSnapshot> _actionMovies = [];

  @override
  void initState() {
    super.initState();
    _getActionMovies();
  }

  Future<void> _getActionMovies() async {
    var actionCategory = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: 'Action')
        .get();

    print('Action category: $actionCategory');

    var actionCategoryId = actionCategory.docs.first.id;

    print('Action category ID: $actionCategoryId');

    var querySnapshot = await FirebaseFirestore.instance
        .collection('movies')
        .where('categories', arrayContains: 'category1')
        .get();
    print('Query snapshot: ${querySnapshot.docs}');
    setState(() {
      _actionMovies = querySnapshot.docs;
    });
    print('Aksiyon filmleri $_actionMovies');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _actionMovies.length,
        itemBuilder: (context, index) {
          var movie = _actionMovies[index].data() as Map<String, dynamic>;

          return ListTile(
            title: Text(movie['title'] ?? ''),
            subtitle: Text(movie['year'].toString()),
          );
        },
      ),
    );
  }
}
