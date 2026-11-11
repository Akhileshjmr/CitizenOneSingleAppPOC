import 'package:citizenone_app/core/session/session_expiry_detector.dart';
import 'package:dio/dio.dart';

/// Builds the interceptor that attaches `X-Session-Token` to every
/// request and reports possible session expiry from responses/errors,
/// so no individual API call needs to do either manually.
///
/// Hooked on both `onResponse` and `onError` because `validateStatus`
/// differs per Dio instance in this codebase — some treat 401/403 as a
/// normal response, others let Dio throw.
InterceptorsWrapper buildSessionInterceptor({
  String? Function()? getToken,
  void Function()? onPossibleExpiry,
  void Function()? onSuccessfulActivity,
}) {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = getToken?.call();
      if (token != null && token.isNotEmpty) {
        options.headers['X-Session-Token'] = token;
      }
      handler.next(options);
    },
    onResponse: (response, handler) {
      if (isSessionExpiryResponse(response)) {
        onPossibleExpiry?.call();
      } else if (isSuccessfulApiResponse(response)) {
        onSuccessfulActivity?.call();
      }
      handler.next(response);
    },
    onError: (error, handler) {
      if (onPossibleExpiry != null &&
          isSessionExpiryResponse(error.response, error: error)) {
        onPossibleExpiry();
      }
      handler.next(error);
    },
  );
}
