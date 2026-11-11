import 'dart:convert';

import 'package:dio/dio.dart' as client;
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../services/session_manager.dart';
import 'auth_inspector.dart';

class APIService {
  static final client.Dio _dio = client.Dio();

  static late String _prodBaseApiUrl;
  static late String _devBaseApiUrl;
  static late String _prodImageBaseUrl;
  static late String _devImageBaseUrl;

  static final SessionManager _sessionManager = SessionManager();

  static bool _initialized = false;

  // --------------------------------------------------
  // BASE URLS
  // --------------------------------------------------

  static String get baseUrl => kReleaseMode ? _prodBaseApiUrl : _devBaseApiUrl;

  static String get imageBaseUrl =>
      kReleaseMode ? _prodImageBaseUrl : _devImageBaseUrl;

  static client.Dio get dio => _dio;

  // --------------------------------------------------
  // INIT
  // --------------------------------------------------

  static void initializeAPIService({
    required String devBaseUrl,
    required String prodBaseUrl,
    required String devImageBaseUrl,
    required String prodImageBaseUrl,
  }) {
    if (_initialized) return;

    _devBaseApiUrl = devBaseUrl;
    _prodBaseApiUrl = prodBaseUrl;
    _devImageBaseUrl = devImageBaseUrl;
    _prodImageBaseUrl = prodImageBaseUrl;

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true),
      );
    }

    _setupInterceptors();

    _dio.interceptors.add(AuthInterceptor(_dio));

    _initialized = true;
  }

  // --------------------------------------------------
  // BASIC INTERCEPTOR
  // --------------------------------------------------

  static void _setupInterceptors() {
    _dio.interceptors.add(
      client.InterceptorsWrapper(
        onRequest: (options, handler) {
          _sessionManager.notifyUserActivity();
          return handler.next(options);
        },

        onResponse: (response, handler) {
          _sessionManager.notifyUserActivity();
          return handler.next(response);
        },

        onError: (error, handler) {
          if (error.response?.statusCode == 302) {
            _sessionManager.forceLogout();
          }

          return handler.next(error);
        },
      ),
    );
  }

  // --------------------------------------------------
  // OPTIONS (NO TOKEN HERE ❌)
  // --------------------------------------------------

  static client.Options get _defaultOptions => client.Options(
    headers: {'Content-Type': 'application/json'},
    responseType: client.ResponseType.json,
  );

  // --------------------------------------------------
  // REQUEST HANDLER
  // --------------------------------------------------

  static Future<client.Response<T>?> _executeRequest<T>(
    Future<client.Response<T>> Function() request, {
    required String method,
  }) async {
    try {
      return await request();
    } catch (e) {
      debugPrint("❌ $method Error: $e");
      return null;
    }
  }

  // --------------------------------------------------
  // GET
  // --------------------------------------------------

  static Future<client.Response<Map<String, dynamic>>?> get({
    required String path,
    Map<String, dynamic>? params,
    client.Options? options,
    String? forcedBaseUrl,
  }) {
    final url = (forcedBaseUrl ?? baseUrl) + path;

    return _executeRequest(
      () => _dio.get(
        url,
        queryParameters: params,
        options: options ?? _defaultOptions,
      ),
      method: 'GET',
    );
  }

  // --------------------------------------------------
  // POST
  // --------------------------------------------------

  static Future<client.Response<Map<String, dynamic>>?> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    client.Options? options,
    String? forcedBaseUrl,
  }) {
    final url = (forcedBaseUrl ?? baseUrl) + path;

    debugPrint("POST: $url");
    debugPrint("BODY: ${jsonEncode(data)}");

    return _executeRequest(
      () => _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: options ?? _defaultOptions,
      ),
      method: 'POST',
    );
  }

  // --------------------------------------------------
  // PUT
  // --------------------------------------------------

  static Future<client.Response<Map<String, dynamic>>?> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) {
    final url = (forcedBaseUrl ?? baseUrl) + path;

    return _executeRequest(
      () => _dio.put(
        url,
        data: data,
        queryParameters: params,
        options: _defaultOptions,
      ),
      method: 'PUT',
    );
  }

  // --------------------------------------------------
  // DELETE
  // --------------------------------------------------

  static Future<client.Response<Map<String, dynamic>>?> delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) {
    final url = (forcedBaseUrl ?? baseUrl) + path;

    return _executeRequest(
      () => _dio.delete(
        url,
        data: data,
        queryParameters: params,
        options: _defaultOptions,
      ),
      method: 'DELETE',
    );
  }

  // --------------------------------------------------
  // PATCH
  // --------------------------------------------------

  static Future<client.Response<Map<String, dynamic>>?> patch({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) {
    final url = (forcedBaseUrl ?? baseUrl) + path;

    return _executeRequest(
      () => _dio.patch(
        url,
        data: data,
        queryParameters: params,
        options: _defaultOptions,
      ),
      method: 'PATCH',
    );
  }
}
