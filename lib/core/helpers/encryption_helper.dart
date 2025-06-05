import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class EncryptionHelper {
  // Génère une clé de 32 octets (256 bits) en appliquant SHA-256
  static final _key = encrypt.Key.fromBase64(base64Encode(
      sha256.convert(utf8.encode('32charslongsecretkeyhere!!12345678')).bytes));
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
