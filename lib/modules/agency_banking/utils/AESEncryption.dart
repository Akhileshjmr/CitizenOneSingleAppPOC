import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

import 'AppLogger.dart';

/// AES-128-GCM encryption service for client ↔ server data protection.
///
/// Security improvements (Phase 1):
///   • Random 12-byte IV per encryption (prevents ciphertext pattern analysis)
///   • IV prepended to ciphertext: output = Base64( IV(12) || ciphertext || tag(16) )
///   • Secret key obfuscated in binary (not a plain string literal)
///   • Backward-compatible decrypt (handles both legacy zero-IV and new random-IV formats)
///
/// ⚠️  Server-side must also be updated to:
///   1. Read the first 12 bytes of decoded payload as IV (instead of assuming zero IV)
///   2. Use the remaining bytes as ciphertext + GCM auth tag
///   3. For a transition period, server should also try legacy zero-IV as fallback
class AESEncryptionService {
  static const int _ivLength = 12; // GCM standard: 96-bit IV
  static const int _tagBits = 128; // GCM auth tag length in bits

  // ──────────────────────────────────────────────
  //  KEY MANAGEMENT
  // ──────────────────────────────────────────────

  /// Retrieve the secret bytes using XOR-obfuscation.
  ///
  /// This prevents the key from appearing as a single plain-text string
  /// in the compiled binary. A `strings` dump or basic decompilation will
  /// no longer reveal the key directly.
  ///
  /// TODO (Phase 2, Item #6): Replace with Android Keystore / iOS Keychain
  /// backed key retrieval from a secure backend endpoint.
  static Uint8List _getSecretBytes() {
    // XOR mask — random bytes used to hide the real key in the binary.
    // real[i] = masked[i] ^ xorKey[i]
    const List<int> xorKey = [
      0xA3,
      0x5F,
      0x1B,
      0x77,
      0xC2,
      0x8E,
      0x04,
      0x91,
      0x6D,
      0xF0,
      0x29,
      0xB4,
      0x3C,
      0xE7,
      0x58,
      0xD1,
    ];

    // Masked secret — the actual key XOR'd with xorKey above.
    // Original: J  m  r  @  1  2  3  4  5  6  ^  %  $  #  @  !
    // Hex:     4A 6D 72 40 31 32 33 34 35 36 5E 25 24 23 40 21
    const List<int> masked = [
      0xE9,
      0x32,
      0x69,
      0x37,
      0xF3,
      0xBC,
      0x37,
      0xA5,
      0x58,
      0xC6,
      0x77,
      0x91,
      0x18,
      0xC4,
      0x18,
      0xF0,
    ];

    final result = Uint8List(masked.length);
    for (int i = 0; i < masked.length; i++) {
      result[i] = masked[i] ^ xorKey[i];
    }
    return result;
  }

  /// Derive a 128-bit AES key from the secret using SHA-1.
  ///
  /// ⚠️  SHA-1 is retained for backward compatibility with the server.
  /// A future phase should migrate both client & server to PBKDF2 or HKDF
  /// with SHA-256 and a proper salt.
  static Uint8List _deriveKey() {
    final secretBytes = _getSecretBytes();
    final hash = sha1.convert(secretBytes).bytes;
    return Uint8List.fromList(hash.sublist(0, 16));
  }

  // ──────────────────────────────────────────────
  //  RANDOM IV GENERATION
  // ──────────────────────────────────────────────

  /// Generate a cryptographically secure random IV using dart:math.
  static Uint8List _generateRandomIV() {
    final rng = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(_ivLength, (_) => rng.nextInt(256)),
    );
  }

  // ──────────────────────────────────────────────
  //  ENCRYPT
  // ──────────────────────────────────────────────

  /// Encrypt [plainText] with AES-128-GCM using a random 12-byte IV.
  ///
  /// Output format: Base64( IV[12] || ciphertext || GCM-tag[16] )
  /// Each call produces different ciphertext for the same input,
  /// preventing replay attacks and pattern identification.
  static String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;

    final key = _deriveKey();
    final iv = _generateRandomIV();

    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      true,
      AEADParameters(KeyParameter(key), _tagBits, iv, Uint8List(0)),
    );

    final encrypted =
        cipher.process(Uint8List.fromList(utf8.encode(plainText)));

    // Prepend IV to ciphertext so the receiver can extract it for decryption
    final combined = Uint8List(iv.length + encrypted.length);
    combined.setAll(0, iv);
    combined.setAll(iv.length, encrypted);

    return base64Encode(combined);
  }

  // ──────────────────────────────────────────────
  //  DECRYPT  (backward-compatible)
  // ──────────────────────────────────────────────

  /// Decrypt [cipherText] trying the new (random-IV) format first,
  /// then falling back to the legacy (zero-IV) format.
  static String decrypt(String cipherText) {
    if (cipherText.isEmpty) return cipherText;

    // Try new format first (IV prepended)
    try {
      return _decryptWithPrependedIV(cipherText);
    } catch (_) {
      // Fall back to legacy zero-IV format
      return _decryptLegacy(cipherText);
    }
  }

  /// Decrypt new format: Base64( IV(12) || ciphertext || tag(16) )
  static String _decryptWithPrependedIV(String cipherText) {
    final combined = base64Decode(cipherText);

    // Must have at least IV + 1 byte of ciphertext + 16 byte tag
    if (combined.length <= _ivLength + 16) {
      throw const FormatException('Payload too short for IV-prepended format');
    }

    final iv = Uint8List.fromList(combined.sublist(0, _ivLength));
    final encrypted = Uint8List.fromList(combined.sublist(_ivLength));

    final key = _deriveKey();
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      false,
      AEADParameters(KeyParameter(key), _tagBits, iv, Uint8List(0)),
    );

    final decrypted = cipher.process(encrypted);
    return utf8.decode(decrypted);
  }

  /// Legacy decrypt: zero IV, SHA-1 derived key (pre-fix format).
  static String _decryptLegacy(String cipherText) {
    final legacySecret = _getSecretBytes();
    final sha1Hash = sha1.convert(legacySecret).bytes;
    final key = Uint8List.fromList(sha1Hash.sublist(0, 16));
    final iv = Uint8List(_ivLength); // all zeros — legacy behavior

    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      false,
      AEADParameters(KeyParameter(key), _tagBits, iv, Uint8List(0)),
    );

    final decrypted = cipher.process(base64Decode(cipherText));
    return utf8.decode(decrypted);
  }

  // ──────────────────────────────────────────────
  //  SAFE DECRYPT (null-safe wrapper)
  // ──────────────────────────────────────────────

  /// Null-safe decrypt that returns the raw value if decryption fails
  /// (e.g. value was never encrypted, or is plain text).
  static String safeDecrypt(String? value) {
    if (value == null) return '';

    final text = value.trim();
    if (text.isEmpty) return '';

    // Quick Base64 sanity check — skip obvious non-encrypted values
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    if (!base64Regex.hasMatch(text) || text.length % 4 != 0) {
      return text;
    }

    try {
      return decrypt(text);
    } catch (e) {
      // Do NOT log the raw value — it may contain sensitive data
      AppLogger.warning(
          'AES safeDecrypt: decryption failed, returning raw value');
      return text;
    }
  }
}
