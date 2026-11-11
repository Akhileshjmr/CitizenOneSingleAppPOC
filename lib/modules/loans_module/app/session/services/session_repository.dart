import '../models/session_payload.dart';
import 'session_api.dart';

class SessionRepository {
  SessionRepository(this._sessionApi);

  final SessionApi _sessionApi;

  Future<SessionPayload> createSession() async {
    final response = await _sessionApi.createSession();
    final data = response.data;

    if (response.statusCode != 200 || data == null) {
      throw const SessionException('Invalid session creation response.');
    }

    return SessionPayload.fromJson(data);
  }

  Future<void> deleteSession({String? sessionToken}) {
    return _sessionApi.deleteSession(sessionToken: sessionToken);
  }

  Future<SessionPayload> refreshSession({String? sessionToken}) async {
    final response = await _sessionApi.refreshSession(sessionToken: sessionToken);
    final data = response.data;
    if (response.statusCode != 200 || data == null) {
      throw const SessionException('Invalid session refresh response.');
    }
    return SessionPayload.fromJson(data);
  }
}
