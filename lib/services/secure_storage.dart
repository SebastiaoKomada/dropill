import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage();

  final _secureStorage = const FlutterSecureStorage();


  Future<void> write({required String key, String? value}) async {
    await _secureStorage.write(
      key: key,
       value: value
    );
  }

  Future<String?> readOne({required String key}) async {
    return _secureStorage.read(key:key);
  }

  Future<Map<String, String>> readAll() async {
      return _secureStorage.readAll();
  }

  Future<void> deleteOne({required String key}) async {
      return _secureStorage.delete(key:key);
  }

  Future<void> deleteAll() async {
      return _secureStorage.deleteAll();
  }
}