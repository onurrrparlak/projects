import 'package:flutter/material.dart';
import 'package:gibireplikleri/services/audioplayer_service.dart';
import 'package:provider/provider.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the percentage-based margin (e.g., 10% of the screen width)
    const double marginPercentage = 0.1; // Adjust this value as needed
    final double marginValue = screenWidth * marginPercentage;

    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        return audioService.isPlaying
            ? Container(
                margin: EdgeInsets.only(bottom: marginValue),
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    audioService.stopSound();
                  },
                  child: const Icon(Icons.stop),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}

