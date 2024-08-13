import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AppVersionScreen extends StatelessWidget {
  final String appVersion = Platform.isAndroid ? '1.0.5' : '1.0.5';

  AppVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Versiyon: $appVersion'));
  }
}
