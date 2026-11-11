import 'dart:io';
import 'dart:convert';
import 'package:citizenone_app/modules/agency_banking/core/Security/DetectSecurity.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';

class CertificatePinningService {
  /// SHA-256 hashes of the server's public key (SubjectPublicKeyInfo).
  ///
  /// To get the pin from your WSO2 gateway, run:
  ///   openssl s_client -connect WSO2_HOST:8243 | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
  ///
  /// Add both the primary and backup certificate pins.
  static const List<String> _pinnedHashes = [
    // TODO: Replace with your actual WSO2 gateway certificate SHA-256 hash
    // Primary certificate pin:
     //'nw0u0TCs+cytIkSarfoo6jpygrx6ZLhO9LGBlJLV5bc=',
    // Backup certificate pin (from a different CA):
     'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];

  /// Apply certificate pinning to a Dio instance.
  /// Only applies when SecurityConfig.enableCertificatePinning is true and pins are configured.
  static void apply(Dio dio) {
    if (!SecurityConfig.enableCertificatePinning) {
      AppLogger.info('Certificate pinning DISABLED');
      return;
    }

    if (_pinnedHashes.isEmpty) {
      AppLogger.info('Certificate pinning SKIPPED — no pins configured');
      return;
    }

    final adapter = dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      adapter.onHttpClientCreate = (client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          return _validateCertificate(cert, host);
        };
        return client;
      };
      AppLogger.warning('Certificate pinning ENABLED (${_pinnedHashes.length} pins)');
    }
  }

  /// Validate the server certificate against pinned hashes.
  /// Returns true if the certificate is trusted, false to reject.
  static bool _validateCertificate(X509Certificate cert, String host) {
    try {
      final certDer = cert.der;
      final hash = sha256.convert(certDer).toString();
      final hashBase64 = base64.encode(sha256.convert(certDer).bytes);

      for (final pin in _pinnedHashes) {
        if (pin == hashBase64 || pin == hash) {
          AppLogger.info('Certificate pin MATCHED for $host');
          return true;
        }
      }

      AppLogger.error('Certificate pin MISMATCH for $host', 'Hash: $hashBase64');
      return false;
    } catch (e) {
      AppLogger.error('Certificate validation error', e);
      return false;
    }
  }

  /// Check if pinning is active and configured.
  static bool get isEnabled => SecurityConfig.enableCertificatePinning && _pinnedHashes.isNotEmpty;
}
