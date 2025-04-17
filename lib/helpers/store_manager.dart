import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../global/global_variables.dart';

class StorageManager {
  static StorageManager? _storageManager;

  StorageManager._createInstance();
  factory StorageManager() {
    _storageManager ??= StorageManager._createInstance();
    return _storageManager!;
  }

  static final secureStorage = EncryptedSharedPreferences();
  static saveData(String key, String? value) async {
    bool res = false;
    if (value is String) {
      res = await secureStorage.setString(key, value);
    }
    return res;
  }

  static Future<dynamic> readData(String key) async {
    List<dynamic> obj = [];
    String? data;
    try {
      data = await secureStorage.getString(key);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      data = "";
    }

    if (data.isEmpty) {
      obj.add(false);
    } else {
      obj.add(true);
    }

    if (obj[0]) {
      obj.add(data);
    } else {
      obj.add("-");
    }

    return obj;
  }

  static deleteData() async {
    bool result = await secureStorage.clear();

    if (enableDebugMode) debugPrint("clearDataResult:$result");
  }
}
