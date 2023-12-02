import 'package:flutter/material.dart';
import 'package:flutter_torrentz_stream/flutter_torrentz_stream.dart';

class TorrentStreamerView extends StatefulWidget {
  @override
  _TorrentStreamerViewState createState() => _TorrentStreamerViewState();
}

class _TorrentStreamerViewState extends State<TorrentStreamerView> {
  bool isStreamReady = false;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    _addTorrentListeners();
  }

  void _addTorrentListeners() {
    TorrentStreamer.addEventListener('progress', (data) {
      setState(() => progress = data['progress']);
    });

    TorrentStreamer.addEventListener('ready', (_) {
      setState(() => isStreamReady = true);
    });
  }

  Future<void> _startDownload() async {
    await TorrentStreamer.start(
        'magnet:?xt=urn:btih:8593E59E39F0D337CA7E90AFB8317BEB2447CBB1&dn=Parasite%20%282019%29%20%5bREPACK%5d%20%5b2160p%5d%20%5b4K%5d%20%5bBluRay%5d%20%5b7.1%5d%20%5bYTS.MX%5d&tr=udp%3a%2f%2ftracker.coppersurfer.tk%3a6969%2fannounce&tr=udp%3a%2f%2f9.rarbg.com%3a2710%2fannounce&tr=udp%3a%2f%2fp4p.arenabg.com%3a1337&tr=udp%3a%2f%2ftracker.internetwarriors.net%3a1337&tr=udp%3a%2f%2ftracker.opentrackr.org%3a1337%2fannounce&tr=udp%3a%2f%2ftracker.zer0day.to%3a1337%2fannounce&tr=udp%3a%2f%2ftracker.leechers-paradise.org%3a6969%2fannounce&tr=udp%3a%2f%2fcoppersurfer.tk%3a6969%2fannounce');
  }

  Future<void> _openVideo(BuildContext context) async {
    if (progress == 100) {
      await TorrentStreamer.launchVideo();
    } else {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
                title: new Text('Are You Sure?'),
                content: new Text(
                    'Playing video while it is still downloading is experimental and only works on limited set of apps.'),
                actions: <Widget>[
                  ElevatedButton(
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  ElevatedButton(
                      child: new Text("Yes, Proceed"),
                      onPressed: () async {
                        await TorrentStreamer.launchVideo();
                        Navigator.of(context).pop();
                      })
                ]);
          },
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: <Widget>[
              ElevatedButton(
                  child: Text('Start Download'), onPressed: _startDownload),
              Container(height: 8),
              ElevatedButton(
                onPressed: () => _openVideo(context),
                child: Text('Play Video'),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max),
        padding: EdgeInsets.all(16));
  }
}
