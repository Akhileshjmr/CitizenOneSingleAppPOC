/// In-memory holder for the agent's raw phone/password, needed to
/// silently authenticate the embedded Agency Banking module without a
/// second login screen. Never persisted to disk.
class AgentBankingCredentialHolder {
  static final AgentBankingCredentialHolder instance =
      AgentBankingCredentialHolder._internal();

  AgentBankingCredentialHolder._internal();

  factory AgentBankingCredentialHolder() => instance;

  String? _mobileNumber = '0971234567';
  String? _password = 'Password123!';

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

