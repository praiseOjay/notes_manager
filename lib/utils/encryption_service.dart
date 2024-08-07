import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final key = Key.fromLength(32);
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encrypt(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
