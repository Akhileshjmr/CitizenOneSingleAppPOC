import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class ReplayProtectionService {
  static const String _hmacAlgorithm = 'HmacSHA256';

  // XOR-obfuscated HMAC secret key (must match server-side values exactly)
  static const List<int> _hmacXorKey = [
    0xB7, 0x4A, 0x2C, 0x63, 0xD8, 0x9F, 0x15, 0x82,
    0x7E, 0xE1, 0x3A, 0xA5, 0x4D, 0xF6, 0x69, 0xC0,
    0x53, 0x0B, 0x8D, 0x74, 0xAE, 0x36, 0xC9, 0x1F,
    0x60, 0xD4, 0x47, 0x98, 0x2E, 0xBB, 0x05, 0xFC,
  ];

  static const List<int> _hmacMaskedSecret = [
    0xE5, 0x7B, 0x5C, 0x2F, 0x98, 0xB4, 0x31, 0xA7,
    0x33, 0x94, 0x09, 0xC4, 0x68, 0xD5, 0x08, 0xA3,
    0x60, 0x6A, 0xBA, 0x44, 0x86, 0x04, 0xAB, 0x75,
    0x09, 0xB7, 0x63, 0xEB, 0x1F, 0xCE, 0x44, 0x91,
  ];

  static Uint8List _deriveHmacKey() {
    final key = Uint8List(_hmacMaskedSecret.length);
    for (int i = 0; i < key.length; i++) {
      key[i] = _hmacMaskedSecret[i] ^ _hmacXorKey[i];
    }
    return key;
  }

  static String generateNonce() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    // Format as UUID v4: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // variant 1
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
  }

  static String computeSignature(String nonce, String sessionId) {
    final key = _deriveHmacKey();
    final data = '$nonce:$sessionId';
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(utf8.encode(data));
    return digest.toString(); // hex string
  }
}

