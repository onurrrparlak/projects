import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../services/videoplayerservice.dart';

class EnterButtonIntent extends Intent {}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = true;
  Timer? _hideTimer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _hideTimer = Timer(Duration(seconds: 8), () {
      setState(() {
        _isVisible = false;
      });
    });
    if (_controller != null) {
      _controller.play();
      setState(() {});
    }

    _controller.setLooping(true);
  }

  Stream<int> _tickStream() {
    return Stream.periodic(Duration(seconds: 1), (i) => i);
  }

  // Dispose of the timer when the screen is disposed
  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
        },
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Actions(
                actions: <Type, Action<Intent>>{
                  EnterButtonIntent: CallbackAction<EnterButtonIntent>(
                    onInvoke: (intent) async {
                      print('içerdema');
                      if (_controller.value.isPlaying) {
                        await _controller.pause();
                      } else {
                        // If the video is paused, play it.
                        await _controller.play();
                      }
                    },
                  ),
                },
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                      // Cancel and restart the timer when the user interact with screen
                      _hideTimer?.cancel();
                      _hideTimer = Timer(Duration(seconds: 8), () {
                        setState(() {
                          _isVisible = false;
                        });
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          AnimatedOpacity(
                            opacity: _isVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.0, 0.05, 0.1, 0.15, 0.2, 1.0],
                                    tileMode: TileMode.clamp,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.5),
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.2),
                                      Colors.black.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                    // Note: adjust the stops and colors array to create your desired gradient
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: _isVisible,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          thumbColor: Colors
                                              .transparent, // Make the thumb (blue dot) invisible
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius:
                                                  0.0), // Change thumb shape to a line
                                          activeTrackColor: Colors
                                              .white, // Change track (line) color to gray
                                          inactiveTrackColor: Colors
                                              .grey, // Change inactive track (line) color to gray
                                        ),
                                        child: Slider(
                                          value: _controller
                                              .value.position.inSeconds
                                              .toDouble(),
                                          min: 0.0,
                                          max: _controller
                                              .value.duration.inSeconds
                                              .toDouble(),
                                          onChanged: (double value) {
                                            setState(() {
                                              Duration duration = Duration(
                                                  seconds: value.toInt());
                                              _controller.seekTo(duration);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.020),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: StreamBuilder(
                                              stream: _tickStream(),
                                              builder: (context, snapshot) {
                                                return Text(
                                                  '${Duration(seconds: (_controller.value.position.inSeconds).toInt()).toString().split('.')[0]}',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _isVisible,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  _controller.value.isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  if (_controller
                                                      .value.isPlaying) {
                                                    await _controller.pause();
                                                  } else {
                                                    // If the video is paused, play it.
                                                    await _controller.play();
                                                  }
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: StreamBuilder(
                                              stream: _tickStream(),
                                              builder: (context, snapshot) {
                                                return Text(
                                                  '-${Duration(seconds: (_controller.value.duration.inSeconds - _controller.value.position.inSeconds).toInt()).toString().split('.')[0]}',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
