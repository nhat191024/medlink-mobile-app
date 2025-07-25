import 'package:get_storage/get_storage.dart' hide Data;

final box = GetStorage();

class StorageService {
  static dynamic readData({required String key}) {
    return box.read(key);
  }

  static bool checkData({required String key}) {
    return box.hasData(key);
  }

  static void writeStringData({required String key, required String value}) {
    box.write(key, value);
  }

  static void writeBoolData({required String key, required bool value}) {
    box.write(key, value);
  }

  static void removeData({required String key}) {
    box.remove(key);
  }

  static void clearAllData() {
    box.erase();
  }
}

class LocalStorageKeys {
  static const String token = "token";
  static const String isTokenExist = "isTokenExist";
}
