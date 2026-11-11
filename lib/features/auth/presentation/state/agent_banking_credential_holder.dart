/// In-memory-only holder for the agent's raw phone/password, needed to
/// silently authenticate the embedded Agency Banking module without a
/// second login screen. Never persisted to disk — mirrors why
/// [SessionEntity]/[AuthState] deliberately omit the password after login.
///
/// Populated once, right after a successful agent login (the one place the
/// raw password is still available before its `TextEditingController` is
/// disposed). Cleared on logout.
class AgentBankingCredentialHolder {
  String? _mobileNumber;
  String? _password;

  void set({required String mobileNumber, required String password}) {
    _mobileNumber = mobileNumber;
    _password = password;
  }

  String? get mobileNumber => _mobileNumber;
  String? get password => _password;

  void clear() {
    _mobileNumber = null;
    _password = null;
  }
}
