import 'package:http/http.dart' as http;
import '../logging/app_logger.dart';
import '../logging/logging_policy.dart';

abstract class NetworkInterceptor {
  Future<Map<String, String>> onRequest(
    String path,
    Map<String, String> headers,
  );
  Future<http.Response> onResponse(String path, http.Response response);
  Future<void> onError(String path, Object error);
}

class DefaultNetworkInterceptor implements NetworkInterceptor {
  final bool enableLogging;

  DefaultNetworkInterceptor({this.enableLogging = true});

  @override
  Future<Map<String, String>> onRequest(
    String path,
    Map<String, String> headers,
  ) async {
    final reqHeaders = Map<String, String>.from(headers);
    if (!reqHeaders.containsKey('Content-Type')) {
      reqHeaders['Content-Type'] = 'application/json';
    }

    if (enableLogging) {
      final sanitizedHeaders = LoggingPolicy.redactHeaders(reqHeaders);
      AppLogger.info(
        '[HTTP-REQ] OUTGOING $path | Headers: $sanitizedHeaders',
      );
    }
    return reqHeaders;
  }

  @override
  Future<http.Response> onResponse(String path, http.Response response) async {
    if (enableLogging) {
      AppLogger.info(
        '[HTTP-RES] SUCCESS $path | Status: ${response.statusCode}',
      );
    }
    return response;
  }

  @override
  Future<void> onError(String path, Object error) async {
    if (enableLogging) {
      AppLogger.error(
        '[HTTP-ERR] ERROR on $path: $error',
      );
    }
  }
}
