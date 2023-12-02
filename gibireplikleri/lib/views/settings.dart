import 'package:flutter/material.dart';
import 'package:gibireplikleri/services/admob_service.dart';
import 'package:gibireplikleri/services/audioplayer_service.dart';
import 'package:gibireplikleri/views/app_version.dart';
import 'package:gibireplikleri/views/contact_us.dart';
import 'package:gibireplikleri/views/rate_the_app.dart';
import 'package:gibireplikleri/views/replik_oner.dart';
import 'package:gibireplikleri/views/share_the_app.dart';
import 'package:gibireplikleri/widgets/gibi_izle.dart';
import 'package:gibireplikleri/widgets/privacy_policy_widget.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late AdMobService _adMobService;
  late final AudioService _audioService = AudioService();

  late bool _kufur;

  @override
  void initState() {
    super.initState();
    _adMobService = AdMobService();

    _adMobService.createRewardedAd();
    _loadSettings();

    Provider.of<SettingsProvider>(context, listen: false).loadSettings();
  }

  @override
  void dispose() {
    _adMobService.dispose();
    _audioService.dispose();
    super.dispose();
  }

  void _loadSettings() async {
    final box = await Hive.openBox('settings');
    if (box.containsKey('kufur')) {
      setState(() {
        _kufur = box.get('kufur');
      });
    }
  }

  void _saveSettings() async {
    final box = await Hive.openBox('settings');
    await box.put('kufur', _kufur);
    var switchValue = box.get('kufur');
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      body: Consumer<SettingsProvider>(builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Ayarlar',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 7,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(color: Colors.white),
                itemBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0:
                      return const gibiIzle();
                    case 1:
                      return ListTile(
                        leading: const Icon(Icons.mail),
                        title: const Text('Bize ulaşın'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomAlertDialog();
                            },
                          );
                        },
                      );
                    case 2:
                      return ShareAppWidget();

                    case 3:
                      return ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('Uygulamayı puanla'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const RatingDialog();
                            },
                          );
                        },
                      );

                    case 4:
                      return ListTile(
                        leading: const Icon(Icons.assistant),
                        title: const Text('Replik Öner'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReplikOner()),
                          );
                        },
                      );
                    case 5:
                      return ListTile(
                          leading: const Icon(Icons.description),
                          title: const Text(
                              'Gizlilik, Politikalar ve Telif Hakkı'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy()),
                            );
                          });

                    case 6:
                      return SwitchListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Küfür gösterilsin mi?'),
                        value: provider.kufur,
                        onChanged: (value) {
                          provider.kufur = value;
                          provider.saveSettings();
                          print(provider.kufur);
                        },
                      );

                    default:
                      return null;
                  }
                },
              ),
            ),
            Column(
              children: [AppVersionScreen()],
            )
          ],
        );
      }),
    );
  }
}
