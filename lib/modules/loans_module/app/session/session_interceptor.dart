import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'session_manager.dart';

class SessionInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.extra['skipSessionToken'] == true) {
      handler.next(options);
      return;
    }

    if (Get.isRegistered<SessionManager>()) {
      final sessionToken = Get.find<SessionManager>().sessionToken;
      if (sessionToken != null && sessionToken.isNotEmpty) {
        options.headers['X-Session-Token'] = sessionToken;
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final skipHandling =
        err.requestOptions.extra['skipSessionExpiryHandling'] == true;

    if (!skipHandling &&
        (statusCode == 401 || statusCode == 403) &&
        Get.isRegistered<SessionManager>()) {
      unawaited(
        Get.find<SessionManager>().handleUnauthorizedResponse(
          statusCode: statusCode,
        ),
      );
    }

    handler.next(err);
  }
}
