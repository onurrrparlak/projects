import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAlertDialog extends StatelessWidget {
  final String email = 'gibireplikleriapp@gmail.com';

  const CustomAlertDialog({super.key});

  void _launchEmailApp(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Display an error message if the email app isn't available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email uygulaması bulunamadı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bize ulaşın'),
      content: RichText(
        text: TextSpan(
          text: 'Bizlere ',
          children: [
            TextSpan(
              text: email,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchEmailApp(context);
                },
            ),
            const TextSpan(
              text: ' adresinden ulaşabilirsiniz.',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}
