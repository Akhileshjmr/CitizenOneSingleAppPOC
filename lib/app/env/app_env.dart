enum Flavor { dev, qa, uat, prod }

class AppEnv {
  final Flavor flavor;

  /// Application-level base URL (legacy / non-agent services).
  final String baseUrl;

  /// Agent User Service base URL — kept separate from [baseUrl] so the
  /// existing app API and the agent login API can co-exist without
  /// breaking the other Dio consumers.
  final String agentApiBaseUrl;
  final String insuranceApiBaseUrl;

  /// Agency Banking gateway base URL (the `agency_banking` module's
  /// `abapigw/agent/channel` backend) — distinct from [agentApiBaseUrl],
  /// which is an unrelated Agent User Service on the same dev host.
  final String agencyBankingBaseUrl;

  final bool enableLogging;

  const AppEnv({
    required this.flavor,
    required this.baseUrl,
    required this.agentApiBaseUrl,
    this.insuranceApiBaseUrl = '',
    this.agencyBankingBaseUrl = '',
    this.enableLogging = false,
  });

  static const dev = AppEnv(
    flavor: Flavor.dev,
    baseUrl: 'https://dev-api.citizenone.app',
    agentApiBaseUrl: 'http://192.168.1.5:8087/api/user',
    insuranceApiBaseUrl: 'http://192.168.1.5:8087/api/insurance',
    agencyBankingBaseUrl: 'http://192.168.1.5:8087',
    enableLogging: true,
  );

  /// Maps to the "SIT" environment from the Insurance Partner API
  /// integration guide.
  static const qa = AppEnv(
    flavor: Flavor.qa,
    baseUrl: 'https://qa-api.citizenone.app',
    agentApiBaseUrl: 'http://192.168.1.5:8087/api/user',
    insuranceApiBaseUrl: 'http://192.168.1.5:8087',
    agencyBankingBaseUrl: 'http://192.168.1.5:8087',
    enableLogging: true,
  );

  static const uat = AppEnv(
    flavor: Flavor.uat,
    baseUrl: 'https://uat-api.citizenone.app',
    agentApiBaseUrl: 'http://192.168.3.69:8082/api/user',
    insuranceApiBaseUrl: 'http://102.23.121.141:8084',
    agencyBankingBaseUrl: 'http://192.168.3.69:8082',
    enableLogging: false,
  );

  static const prod = AppEnv(
    flavor: Flavor.prod,
    baseUrl: 'https://api.citizenone.app',
    agentApiBaseUrl: 'http://192.168.3.69:8082/api/user',
    insuranceApiBaseUrl: 'https://frontab.citizenonezm.com:8243',
    agencyBankingBaseUrl: 'http://192.168.3.69:8082',
    enableLogging: false,
  );

  Uri insuranceUri(String path) {
    final base = insuranceApiBaseUrl.replaceFirst(RegExp(r'/+$'), '');
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$normalizedPath');
  }
}
