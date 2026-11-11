import 'dart:io' show InternetAddress;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  // dart:io's InternetAddress.lookup has no browser implementation and
  // throws on web, so the DNS-based double-check below only runs on
  // platforms where it actually works. On web, the connectivity_plus
  // result (backed by navigator.onLine) is used as-is.
  static Future<bool> _canReachInternet() async {
    if (kIsWeb) return true;

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();

    final hasNetwork = results.any((res) => res != ConnectivityResult.none);

    if (!hasNetwork) {
      return false;
    }

    return _canReachInternet();
  }

  static Stream<bool> get connectionStream async* {
    await for (final results in _connectivity.onConnectivityChanged) {
      final hasNetwork = results.any((res) => res != ConnectivityResult.none);

      if (!hasNetwork) {
        yield false;
      } else {
        yield await _canReachInternet();
      }
    }
  }
}
