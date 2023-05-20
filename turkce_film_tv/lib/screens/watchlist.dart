import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';

class UserWatchlistPage extends StatefulWidget {
  const UserWatchlistPage({super.key});

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
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final movies = snapshot.data!.docs;

            final watchedMovies = movies
                .where(
                    (doc) => (doc.data() as Map<String, dynamic>)['isWatched'])
                .toList();

            final notWatchedMovies = movies
                .where(
                    (doc) => !(doc.data() as Map<String, dynamic>)['isWatched'])
                .toList();

            return movies.isEmpty
                ? const Text('Listenize henüz film eklememişsiniz')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            'İzleyeceklerim (${notWatchedMovies.length})',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
                                fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: notWatchedMovies.length,
                          itemBuilder: (context, index) {
                            final movieId = (notWatchedMovies[index].data()
                                as Map<String, dynamic>)['movieId'];

                            return Row(
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_currentUser.uid)
                                              .collection('watchlist')
                                              .where('movieId',
                                                  isEqualTo: movieId)
                                              .get()
                                              .then((snapshot) async {
                                            if (snapshot.docs.isNotEmpty) {
                                              final movieRef =
                                                  snapshot.docs.first.reference;
                                              await movieRef.delete();
                                            }
                                          });
                                        } catch (e) {
                                          print(
                                              'Error deleting movie from watchlist: $e');
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_currentUser.uid)
                                              .collection('watchlist')
                                              .where('movieId',
                                                  isEqualTo: movieId)
                                              .get()
                                              .then((snapshot) async {
                                            if (snapshot.docs.isNotEmpty) {
                                              final movieRef =
                                                  snapshot.docs.first.reference;
                                              final isWatched = snapshot
                                                  .docs.first
                                                  .data()['isWatched'];
                                              await movieRef.update(
                                                  {'isWatched': !isWatched});
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(_currentUser.uid)
                                                  .collection('watchlist')
                                                  .add({
                                                'movieId': movieId,
                                                'isWatched': false,
                                              });
                                            }
                                          });
                                        } catch (e) {
                                          print(
                                              'Error updating movie watched status: $e');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                FutureBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('movies')
                                      .where('movieId', isEqualTo: movieId)
                                      .limit(1)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    var movieData =
                                        snapshot.data!.docs.first.data();
                                    final movieTitle = movieData['title'];
                                    final movieUrl = movieData['url'];

                                    final movieImage =
                                        movieData['posterImageUrl'];

                                    return GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                              videoUrl: movieUrl,
                                            ),
                                          ),
                                        );
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 5 / 3,
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.0045,
                                          ),
                                          child: Image.network(
                                            movieImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('İzlediklerim (${watchedMovies.length})',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
                                fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: watchedMovies.length,
                          itemBuilder: (context, index) {
                            final movieId = (watchedMovies[index].data()
                                as Map<String, dynamic>)['movieId'];

                            return Row(
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_currentUser.uid)
                                              .collection('watchlist')
                                              .where('movieId',
                                                  isEqualTo: movieId)
                                              .get()
                                              .then((snapshot) async {
                                            if (snapshot.docs.isNotEmpty) {
                                              final movieRef =
                                                  snapshot.docs.first.reference;
                                              await movieRef.delete();
                                            }
                                          });
                                        } catch (e) {
                                          print(
                                              'Error deleting movie from watchlist: $e');
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_currentUser.uid)
                                              .collection('watchlist')
                                              .where('movieId',
                                                  isEqualTo: movieId)
                                              .get()
                                              .then((snapshot) async {
                                            if (snapshot.docs.isNotEmpty) {
                                              final movieRef =
                                                  snapshot.docs.first.reference;
                                              final isWatched = snapshot
                                                  .docs.first
                                                  .data()['isWatched'];
                                              await movieRef.update(
                                                  {'isWatched': !isWatched});
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(_currentUser.uid)
                                                  .collection('watchlist')
                                                  .add({
                                                'movieId': movieId,
                                                'isWatched': false,
                                              });
                                            }
                                          });
                                        } catch (e) {
                                          print(
                                              'Error updating movie watched status: $e');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                FutureBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('movies')
                                      .where('movieId', isEqualTo: movieId)
                                      .limit(1)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    var movieData =
                                        snapshot.data!.docs.first.data();
                                    final movieTitle = movieData['title'];
                                    final movieUrl = movieData['url'];

                                    final movieImage =
                                        movieData['posterImageUrl'];
                                    String? subtitle =
                                        movieData.containsKey('subtitle')
                                            ? movieData['subtitle']
                                            : null;

                                    return GestureDetector(
                                      onTap: () async {},
                                      child: AspectRatio(
                                        aspectRatio: 5 / 3,
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.0045,
                                          ),
                                          child: Image.network(
                                            movieImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
