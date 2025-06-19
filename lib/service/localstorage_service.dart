
import 'package:get_storage/get_storage.dart' hide Data;
final box = GetStorage();

class StorageService {
  static dynamic readData({
    required String key,
  }) {
    return box.read(key);
  }

  static bool checkData({
    required String key,
  }) {
    return box.hasData(key);
  }

  static writeStringData({
    required String key,
    required String value,
  }) {
    box.write(key, value);
  }

  static writeBoolData({
    required String key,
    required bool value,
  }) {
    box.write(key, value);
  }

  static removeData({
    required String key,
  }) {
    box.remove(key);
  }
}

class LocalStorageKeys {
  static const String token = "token";
}
