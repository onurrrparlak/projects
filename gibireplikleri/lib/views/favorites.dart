import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gibireplikleri/core/replikler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

class Favorites extends StatelessWidget {
  Favorites({Key? key}) : super(key: key);

  List repliklerList = Replikler.replikler;
  final audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Favoriler',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: const BoxDecoration(
              color: Color(0xFF1d1c21),
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              )),
          child: ValueListenableBuilder(
              valueListenable: Hive.box('favoriler').listenable(),
              builder: (context, box, child) {
                List posts = List.from(box.values);
                final isFavorite = posts != null;
                if (posts.isNotEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      ...posts.map(
                        (p) => ListTile(
                          onTap: () {
                            audioPlayer.stop();
                            audioPlayer.play(AssetSource(
                                'sounds/${p['id']}.mp3'));
                          },
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/images/${p['soyleyen'] == 0
                                    ? 'yilmaz.jpg'
                                    : p['soyleyen'] == 1
                                        ? 'ilkkan.jpg'
                                        : 'ersoy.jpg'}'),
                          ),
                          title: Text(
                            p['replik'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Wrap(
                            spacing: -10,
                            children: [
                              Material(
                                color: Colors.transparent,
                                clipBehavior: Clip.hardEdge,
                                shape: const CircleBorder(),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: () async {
                                    await box.delete(p['id']);
                                  },
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                clipBehavior: Clip.hardEdge,
                                shape: const CircleBorder(),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                  ),
                                  onPressed: () async {
                                    final data = await rootBundle.load(
                                        'assets/sounds/${p['id']}.mp3');
                                    final buffer = data.buffer;
                                    await Share.shareXFiles([
                                      XFile.fromData(
                                        buffer.asUint8List(data.offsetInBytes,
                                            data.lengthInBytes),
                                        mimeType: 'audio/x-aiff',
                                      )
                                    ]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                      child: Text(
                          'Listenize henüz bir favori replik eklememişsiniz.'));
                }
              }),
        ),
      ],
    );
  }
}
