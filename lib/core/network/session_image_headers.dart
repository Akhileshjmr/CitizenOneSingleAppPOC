import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/session/presentation/state/session_cubit.dart';

/// Headers for authenticated image requests (`Image.network`/
/// `NetworkImage`), which — unlike [DioClient] calls — never pass
/// through `buildSessionInterceptor` and so never get `X-Session-Token`
/// attached automatically.
///
/// Reads the same live token [DioClient] uses (via [SessionCubit]), so
/// image requests never carry a separate or stale token.
Map<String, String> sessionImageHeaders() {
  final token = sl<SessionCubit>().currentToken;
  if (token == null || token.isEmpty) return const {};
  return {'X-Session-Token': token};
}
