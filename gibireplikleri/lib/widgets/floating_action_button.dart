import 'package:flutter/material.dart';
import 'package:gibireplikleri/services/audioplayer_service.dart';
import 'package:provider/provider.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        return audioService.isPlaying
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onPressed: () {
                  audioService.stopSound();
                },
                child: const Icon(Icons.stop),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
