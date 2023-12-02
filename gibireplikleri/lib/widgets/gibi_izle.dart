import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class gibiIzle extends StatelessWidget {
  const gibiIzle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tv),
      title: const Text('Gibi dizisini hemen izle'),
      onTap: () {
        _launchPlayStore();
      },
    );
  }

  _launchPlayStore() async {
    const url = 'market://details?id=com.exxen.android';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch Play Store URL';
    }
  }
}
