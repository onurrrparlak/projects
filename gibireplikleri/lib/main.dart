import 'package:flutter/material.dart';
import 'package:gibireplikleri/gibi_icons_icons.dart';
import 'package:gibireplikleri/provider/settings_provider.dart';
import 'package:gibireplikleri/services/admob_service.dart';
import 'package:gibireplikleri/services/audioplayer_service.dart';

import 'package:gibireplikleri/views/favorites.dart';
import 'package:gibireplikleri/views/homepage.dart';
import 'package:gibireplikleri/views/settings.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await MobileAds.instance.initialize();
  await Hive.openBox('favoriler');
  await Hive.openBox('settings');
  await Hive.openBox('replikBox');

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  final hiveBox = await Hive.openBox('adBox', path: appDocumentDir.path);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AudioService>(create: (_) => AudioService()),
      ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider()),
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/settings': (context) => Settings(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1d1c21),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(width: 0, color: Color(0xFF1d1c21)),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 0, color: Color(0xFF1d1c21)))),
        fontFamily: 'Euclid',
        scaffoldBackgroundColor: const Color(0xFF09090F),
      ),
      home: FutureBuilder(
        future: Future.wait([
          Hive.openBox('favoriler'),
          Hive.openBox('settings'),
          Hive.openBox('replikBox'),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Once the initialization is complete, show the main content of the app
            return SafeArea(child: MyHomePage());
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _screenIndex = 0;
  final List _screens = [
    {"screen": Homepage()},
    {"screen": Favorites()},
    {"screen": Settings()}
  ];

  void _selectScreen(int index) {
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_screenIndex]["screen"],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Container(
          height: 75,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: BottomNavigationBar(
            selectedItemColor: Colors.white,
            currentIndex: _screenIndex,
            showSelectedLabels: false,
            showUnselectedLabels: true,
            onTap: _selectScreen,
            backgroundColor: Color(0xFF1d1c21),
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  GibiIcons.home_1,
                  size: _screenIndex == 0 ? 25 : 20,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    GibiIcons.heart,
                    size: _screenIndex == 1 ? 25 : 20,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    GibiIcons.menu,
                    size: _screenIndex == 2 ? 25 : 20,
                  ),
                  label: '')
            ],
          ),
        ),
      ),
    );
  }
}
