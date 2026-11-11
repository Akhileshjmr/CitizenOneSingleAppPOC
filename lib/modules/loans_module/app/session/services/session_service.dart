import '../models/session_payload.dart';
import 'session_repository.dart';

class SessionService {
  // Existing methods remain unchanged
  // New method to refresh session token
  Future<SessionPayload> refreshSession({String? sessionToken}) {
    return _repository.refreshSession(sessionToken: sessionToken);
  }
  SessionService(this._repository);

  final SessionRepository _repository;

  Future<SessionPayload> createSession() {
    return _repository.createSession();
  }

  Future<void> deleteSession({String? sessionToken}) {
    return _repository.deleteSession(sessionToken: sessionToken);
  }
}
