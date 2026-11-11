import 'package:get_it/get_it.dart';
import 'package:citizenone_app/modules/insurance/core/session/session_token_provider.dart';

/// Headers for authenticated image requests (`AppNetworkImage`/
/// `Image.network`), which — unlike requests made through the shared
/// [DioClient] — never pass through its interceptor and so never get
/// `X-Session-Token` attached automatically.
///
/// Reads the same live token the host app (CitizenOne) supplies via
/// [SessionTokenProvider] — the one seam this module uses for session
/// state — so image requests never carry a separate or stale token.
/// Defensive like [DioClient]: resolves to no headers if the host
/// hasn't registered a [SessionTokenProvider] (e.g. this module running
/// standalone/under test).
Map<String, String> sessionImageHeaders() {
  final sl = GetIt.instance;
  if (!sl.isRegistered<SessionTokenProvider>()) return const {};
  final token = sl<SessionTokenProvider>().currentToken;
  if (token == null || token.isEmpty) return const {};
  return {'X-Session-Token': token};
}
