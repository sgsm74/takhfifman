import 'package:hive_flutter/hive_flutter.dart';

import '../models/discount_code.dart';

class LocalStorage {
  static final _box = Hive.box<DiscountCode>('codes');

  static Future<void> saveCodes(List<DiscountCode> codes) async {
    for (var code in codes) {
      final exists = _box.values.any((c) => c.code == code.code && c.brand == code.brand);
      if (!exists) {
        await _box.add(code);
      }
    }
  }

  static List<DiscountCode> getAllCodes() {
    return _box.values.toList();
  }

  static Future<void> deleteCode(int index) async {
    await _box.deleteAt(index);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}
