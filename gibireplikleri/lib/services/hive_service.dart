import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  late Box _box;
  static const _isSwitchedKey = 'isSwitched';

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('myBox');
  }

  bool get isSwitched => _box.get(_isSwitchedKey, defaultValue: false);

  set isSwitched(bool value) => _box.put(_isSwitchedKey, value);

  Future<void> close() async {
    await _box.close();
    await Hive.close();
  }
}
