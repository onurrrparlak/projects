import 'package:video_player/video_player.dart';

class VideoPlayerService {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  Future<VideoPlayerController> init(String url) async {
    _controller = VideoPlayerController.network(url);
    await _controller.initialize();
    _controller.setLooping(true);
    return _controller;
  }

  Future<void> play() async {
    if (!_isPlaying) {
      await _controller.play();
      _isPlaying = true;
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _controller.pause();
      _isPlaying = false;
    }
  }

  void dispose() {
    _controller.dispose();
  }
}
