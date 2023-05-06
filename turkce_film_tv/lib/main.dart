import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/firebase_options.dart';
import 'package:turkce_film_tv/provider/movie_provider.dart';
import 'package:turkce_film_tv/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkce_film_tv/screens/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  ).then((_) async {
    final movieProvider = MovieProvider();
    await movieProvider.fetchMovies();

    runApp(
      ChangeNotifierProvider.value(
        value: movieProvider,
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Carossoft',
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return LoginPage();
              }
            },
          ),
        ),
      ),
    );
  });
}
