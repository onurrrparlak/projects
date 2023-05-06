// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAPw85XOEaib43yRC2S-FN1fYnaHWMdRwg',
    appId: '1:351397556708:web:48711b71e92826a0a357f1',
    messagingSenderId: '351397556708',
    projectId: 'turkcefilmtv-ec48c',
    authDomain: 'turkcefilmtv-ec48c.firebaseapp.com',
    storageBucket: 'turkcefilmtv-ec48c.appspot.com',
    measurementId: 'G-66R1TQ4R8L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZ4JzUJreyWHB8hENUQ71zGGF1f68Cp0U',
    appId: '1:351397556708:android:bf78f02312847426a357f1',
    messagingSenderId: '351397556708',
    projectId: 'turkcefilmtv-ec48c',
    storageBucket: 'turkcefilmtv-ec48c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_5YAyp20mhGfcqyDxj-eGiZGZkdZfe4I',
    appId: '1:351397556708:ios:36c7027809518100a357f1',
    messagingSenderId: '351397556708',
    projectId: 'turkcefilmtv-ec48c',
    storageBucket: 'turkcefilmtv-ec48c.appspot.com',
    iosClientId: '351397556708-olou8m6oj33jgfjjkrtmgm03n4qlthfr.apps.googleusercontent.com',
    iosBundleId: 'com.example.turkceFilmTv',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_5YAyp20mhGfcqyDxj-eGiZGZkdZfe4I',
    appId: '1:351397556708:ios:36c7027809518100a357f1',
    messagingSenderId: '351397556708',
    projectId: 'turkcefilmtv-ec48c',
    storageBucket: 'turkcefilmtv-ec48c.appspot.com',
    iosClientId: '351397556708-olou8m6oj33jgfjjkrtmgm03n4qlthfr.apps.googleusercontent.com',
    iosBundleId: 'com.example.turkceFilmTv',
  );
}
