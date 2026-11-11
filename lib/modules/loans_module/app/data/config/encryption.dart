import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class AppEncryption {
  /// Hardcoded 32-byte AES-256 key
  static final Key _key = Key.fromUtf8('9xK2mP4sT7vW0yZ3aBcDeFgHiJkLmNoP');

  static final Encrypter _encrypter = Encrypter(AES(_key, mode: AESMode.ctr));

  /// Encrypt text
  static String encrypt({required String plainText}) {
    final iv = IV.fromSecureRandom(16);

    final encrypted = _encrypter.encrypt(plainText, iv: iv);

    final combined = iv.bytes + encrypted.bytes;

    return base64Encode(combined);
  }

  /// Decrypt text
  static String decrypt({required String cipherText}) {
    final combined = base64Decode(cipherText);

    final iv = IV(Uint8List.fromList(combined.sublist(0, 16)));

    final encryptedBytes = combined.sublist(16);

    final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));

    return _encrypter.decrypt(encrypted, iv: iv);
  }
}
