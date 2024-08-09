import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service class for securely storing and retrieving sensitive data.
class SecureStorage {
  final _storage = const FlutterSecureStorage();

  /// Writes a key-value pair to secure storage.
  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from secure storage given a key.
  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a key-value pair from secure storage.
  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }
}

