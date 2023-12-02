import 'dart:math';

import 'package:hive/hive.dart';

class ReplikService {
  static const _replikBoxName = 'replik_box';
  static const _replikKey = 'replik';

  final _random = Random();

  late Box _replikBox;

  Future<void> init() async {
    await Hive.openBox(_replikBoxName);
    _replikBox = Hive.box(_replikBoxName);
  }

  String _generateReplik() {
    final replikMap = {
      0: 'Replik 1',
      1: 'Replik 2',
      2: 'Replik 3',
      3: 'Replik 4',
      4: 'Replik 5',
    };
    final index = _random.nextInt(replikMap.length);
    return replikMap[index]!;
  }

  String getReplik() {
    final storedReplik = _replikBox.get(_replikKey) as String?;
    if (storedReplik != null) {
      return storedReplik;
    }
    final generatedReplik = _generateReplik();
    _replikBox.put(_replikKey, generatedReplik);
    return generatedReplik;
  }

  Future<void> updateReplik() async {
    final generatedReplik = _generateReplik();
    await _replikBox.put(_replikKey, generatedReplik);
  }
}
