import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  bool _kufur = true;

  bool get kufur => _kufur;

  bool getKufur() {
    return _kufur;
  }

  set kufur(bool value) {
    _kufur = value;
    notifyListeners();
  }

  void loadSettings() async {
    final box = await Hive.openBox('settings');
    _kufur = box.get('kufur') ?? false;
    notifyListeners();
  }

  void saveSettings() async {
    final box = await Hive.openBox('settings');
    await box.put('kufur', _kufur);
    notifyListeners();
  }
}
