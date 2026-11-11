import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_env.dart';
import 'api_exception.dart';
import 'network_interceptor.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  final NetworkInterceptor interceptor;
  final AppEnv? env;

  ApiClient({
    String? baseUrl,
    this.env,
    http.Client? client,
    NetworkInterceptor? interceptor,
  })  : baseUrl = baseUrl ?? env?.apiBaseUrl ?? 'https://api.citizenone.example.com',
        _client = client ?? http.Client(),
        interceptor = interceptor ??
            DefaultNetworkInterceptor(
              enableLogging: env?.enableLogging ?? true,
            );

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});

    try {
      final response = await _client.get(uri, headers: reqHeaders);
      return await _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException(
        'Network GET request failed: $e',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await _client.post(
        uri,
        headers: reqHeaders,
        body: encodedBody,
      );
      return await _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException(
        'Network POST request failed: $e',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await _client.put(
        uri,
        headers: reqHeaders,
        body: encodedBody,
      );
      return await _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException(
        'Network PUT request failed: $e',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});

    try {
      final response = await _client.delete(uri, headers: reqHeaders);
      return await _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException(
        'Network DELETE request failed: $e',
        originalError: e,
      );
    }
  }

  Future<Map<String, dynamic>> _processResponse(
    String path,
    http.Response response,
  ) async {
    final intercepted = await interceptor.onResponse(path, response);

    if (intercepted.statusCode >= 200 && intercepted.statusCode < 300) {
      if (intercepted.body.isEmpty) return {};
      return jsonDecode(intercepted.body) as Map<String, dynamic>;
    }

    switch (intercepted.statusCode) {
      case 400:
        throw BadRequestException(
          'Bad Request',
          statusCode: 400,
          responseBody: intercepted.body,
        );
      case 401:
        throw UnauthorizedException(
          'Unauthorized session',
          statusCode: 401,
          responseBody: intercepted.body,
        );
      case 403:
        throw ForbiddenException(
          'Access forbidden',
          statusCode: 403,
          responseBody: intercepted.body,
        );
      case 404:
        throw NotFoundException(
          'Endpoint not found',
          statusCode: 404,
          responseBody: intercepted.body,
        );
      case 500:
      default:
        throw ServerException(
          'Server Error: ${intercepted.statusCode}',
          statusCode: intercepted.statusCode,
          responseBody: intercepted.body,
        );
    }
  }
}
