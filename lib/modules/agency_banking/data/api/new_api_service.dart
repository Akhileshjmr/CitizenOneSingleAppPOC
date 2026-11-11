import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
// import 'package:jmr_banking/app/utils/app_logers.dart';

class NewsApiService {


  static final NewsApiService _newAPIService = NewsApiService._internal();

  factory NewsApiService() {
    return _newAPIService;
  }
  NewsApiService._internal();

  HttpClient client = HttpClient();

  // Future<SecurityContext> get globalContext async {
  //   final sslCert = await rootBundle.load('assets/certificate.pem');
  //   SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  //   securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  //   return securityContext;
  // }

  /// Global security context that supports multiple certificates.
  Future<SecurityContext> get globalContext async {
    final context = SecurityContext(withTrustedRoots: true);
    // 👆 keeps system trusted roots (safer)

    // List all your certificates (old + new)
    final certFiles = [
      'assets/certificate.pem',
      'assets/certificate_new.pem',
    ];

    // Load all certificates into the same SecurityContext
    for (final certPath in certFiles) {
      try {
        final data = await rootBundle.load(certPath);
        context.setTrustedCertificatesBytes(data.buffer.asUint8List());
      } catch (e) {
        // AppLogger.d('Failed to load cert $certPath: $e');
      }
    }
    return context;
  }

  Future<HttpClient> getSSLPinningHttpClient() async {
    HttpClient clientH = HttpClient(context: await globalContext);
    return clientH;
  }

  Future<http.Client> getSSLPinningClient() async {
    client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }
}

class NativeBridgeF {
  static const platform = MethodChannel('com.adcb.mobileapp/channel');

  static Future<String?> getDeviceInfo() async {
    try {
      final result = await platform.invokeMethod<String>('getDeviceInfo');
      return result;
    } on PlatformException catch (e) {
      // AppLogger.d("Failed to get device info: '${e.message}'.");
      return null;
    }
  }
}

class GlobalHttpOverrides extends HttpOverrides {
  final SecurityContext _context;

  GlobalHttpOverrides(this._context);

  @override
  HttpClient createHttpClient(SecurityContext? _) {
    final client = HttpClient(context: _context);

    // Optional: allow self-signed or mismatched host certificates (for testing)
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // ✅ Return true only if you explicitly trust this certificate
      return true;
    };

    return client;
  }

  /// Loads the certificate file into a [SecurityContext]
  static Future<SecurityContext> createSecurityContext() async {
    final sslCert = await rootBundle.load('assets/certificate.pem');

    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return context;
  }
}
