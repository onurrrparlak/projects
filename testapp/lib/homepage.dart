import 'package:flutter/material.dart';
import 'package:testapp/admob_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdMobService _adMobService = AdMobService(); // Initialize AdMobService

  @override
  void initState() {
    super.initState();
    _adMobService.initialize(); // Initialize AdMob ads
  }

  @override
  void dispose() {
    _adMobService.dispose(); // Dispose AdMobService
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdMob Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app content here
            Text('Welcome to the Homepage'),
            SizedBox(height: 20),
            // Display Banner Ad
            _adMobService.showBannerAd(),
            SizedBox(height: 20),
            // Button to trigger Rewarded Ad
            ElevatedButton(
              onPressed: () {
                _adMobService.adDismissedCallback = () {
                  // Implement action after ad dismissal (if needed)
                  print('Rewarded Ad dismissed');
                };
                _adMobService.showRewardedAd();
              },
              child: Text('Show Rewarded Ad'),
            ),
          ],
        ),
      ),
    );
  }
}
