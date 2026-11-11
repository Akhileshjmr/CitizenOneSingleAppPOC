import 'package:citizenone_app/core/utils/date_parsing.dart';

import '../../domain/entities/session_entity.dart';
import '../models/login_response_model.dart';

/// Maps the wire-level [SessionValue] (login/refresh `data` payload) to
/// the domain [SessionEntity]. Shared by [AuthRepositoryImpl] (login)
/// and the session refresh data source, since both endpoints return
/// the same envelope.
SessionEntity mapSessionValueToEntity(SessionValue? value) {
  if (value == null) return const SessionEntity();
  return SessionEntity(
    sessionToken: value.sessionToken,
    issuedAt: parseFlexibleDate(value.issuedAt),
    expiresAt: parseFlexibleDate(value.expiresAt),
    validitySeconds: value.validitySeconds,
    mustChangePassword: value.mustChangePassword,
    userType: value.userType,
  );
}
