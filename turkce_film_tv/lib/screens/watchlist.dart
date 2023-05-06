import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';

class UserWatchlistPage extends StatefulWidget {
  @override
  _UserWatchlistPageState createState() => _UserWatchlistPageState();
}

class _UserWatchlistPageState extends State<UserWatchlistPage> {
  late final User _currentUser;
  late final CollectionReference _watchlistRef;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _watchlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('watchlist');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.06,
          MediaQuery.of(context).size.width * 0.02,
          MediaQuery.of(context).size.width * 0.06,
          MediaQuery.of(context).size.width * 0.02,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _watchlistRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movies = snapshot.data!.docs.map((doc) => doc.id).toList();
              return GridView.builder(
                itemCount: movies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 5 / 3,
                ),
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('movies')
                        .doc(movies[index].toString())
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final movie = snapshot.data!;
                        final movieData = movie.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  videoUrl: movie.get('url'),
                                  subtitle: movieData.containsKey('subtitle')
                                      ? movieData['subtitle']
                                      : null,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: AspectRatio(
                              aspectRatio: 5 / 3,
                              child: Container(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.0045,
                                ),
                                child: Image.network(
                                  movie.get('posterImageUrl'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
