import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final _key =
      encrypt.Key.fromUtf8('32charslongsecretkeyhere!!12345678'); // 32 chars
  static final _iv = encrypt.IV.fromLength(16);

  static List<int> encryptData(List<int> data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encryptBytes(data, iv: _iv);
    return encrypted.bytes;
  }

  static List<int> decryptData(String encryptedBase64) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypt.Encrypted(base64Decode(encryptedBase64));
    final decrypted = encrypter.decryptBytes(encrypted, iv: _iv);
    return decrypted;
  }
}
