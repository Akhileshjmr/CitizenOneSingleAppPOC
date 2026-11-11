import 'package:dio/dio.dart';

/// Best-guess heuristic for "this response means the session is no
/// longer valid" — **no backend contract for this has been confirmed
/// yet**. Isolated in this single function so tightening it later (once
/// the real contract is known) is a one-place change.
///
/// Current rule: HTTP 401/403, or a business-error `chMessage.code`
/// (not the free-text `message`, to avoid false-positiving on ordinary
/// validation errors such as "Invalid mobile number") containing
/// `SESSION`, `UNAUTHORIZED`, or `EXPIRED`.
bool isSessionExpiryResponse(Response<dynamic>? response, {DioException? error}) {
  final status = response?.statusCode ?? error?.response?.statusCode;
  if (status == 401 || status == 403) return true;

  final data = response?.data ?? error?.response?.data;
  if (data is Map && data['chMessage'] is Map) {
    final chMessage = data['chMessage'] as Map;
    final isError = chMessage['isError'] as bool? ?? false;
    if (!isError) return false;
    final code = (chMessage['code'] as String? ?? '').toUpperCase();
    const keywords = ['SESSION', 'UNAUTHORIZED', 'EXPIRED'];
    return keywords.any(code.contains);
  }

  return false;
}

/// Whether a response represents valid, successfully-processed user
/// activity — the signal that resets the global inactivity timer.
///
/// Only ever meaningful for `onResponse` (never `onError`): a response
/// that reaches `onResponse` has already come back from the server, so
/// this never fires for network failures/timeouts, which are reported
/// through `onError` instead. Deliberately checked as the complement of
/// [isSessionExpiryResponse] rather than independently, so the two can
/// never both be true for the same response.
///
/// Uses the same `chMessage.isError` envelope every response model in
/// this app already checks (e.g. `LoginResponseModel.isSuccess`) rather
/// than introducing a second, inconsistent success contract. A 2xx
/// response with no `chMessage` envelope (e.g. a plain REST/vendor
/// endpoint) is treated as successful.
bool isSuccessfulApiResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  if (status == null || status < 200 || status >= 300) return false;
  if (isSessionExpiryResponse(response)) return false;

  final data = response?.data;
  if (data is Map && data['chMessage'] is Map) {
    final isError = (data['chMessage'] as Map)['isError'] as bool? ?? false;
    return !isError;
  }

  return true;
}
