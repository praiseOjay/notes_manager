import 'package:encrypt/encrypt.dart';

/// Service class for encrypting and decrypting sensitive data.
class EncryptionService {
  // Use a secure method to generate and store these keys in a production environment
  static final Key _key = Key.fromLength(32);
  static final IV _iv = IV.fromLength(16);
  static final Encrypter _encrypter = Encrypter(AES(_key));

  /// Encrypts the given plain text.
  ///
  /// Returns the encrypted text as a base64 encoded string.
  static String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypts the given encrypted text.
  ///
  /// The encrypted text should be a base64 encoded string.
  /// Returns the decrypted plain text.
  static String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

