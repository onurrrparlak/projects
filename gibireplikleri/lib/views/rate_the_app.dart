import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RatingDialog extends StatelessWidget {
  const RatingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Uygulamamızı beğendiniz mi?"),
      content: const Text("Lütfen bize Play Store üzerinden puan verin"),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("İptal"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Puan ver"),
          onPressed: () async {
            const url =
                "https://example.com/rate"; // replace with your app store link
            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
