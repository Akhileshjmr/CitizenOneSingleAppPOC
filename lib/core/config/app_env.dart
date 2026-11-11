enum EnvironmentType { dev, staging, prod }

/// Configuration class governing runtime environment flavors and transport security.
/// Enforces fail-closed TLS compliance in production mode as mandated by CitizenOne Architecture.
class AppEnv {
  final EnvironmentType environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableCertificatePinning;

  const AppEnv._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableCertificatePinning,
  });

  /// Factory for Development environment
  factory AppEnv.dev({
    String apiBaseUrl = 'https://dev-api.citizenone.example.com',
    bool enableLogging = true,
  }) {
    return AppEnv._(
      environment: EnvironmentType.dev,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      enableCertificatePinning: false,
    );
  }

  /// Factory for Staging / UAT environment
  factory AppEnv.staging({
    String apiBaseUrl = 'https://staging-api.citizenone.example.com',
    bool enableLogging = true,
    bool enableCertificatePinning = true,
  }) {
    return AppEnv._(
      environment: EnvironmentType.staging,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      enableCertificatePinning: enableCertificatePinning,
    );
  }

  /// Factory for Production environment.
  /// Strictly enforces HTTPS/TLS and rejects plain HTTP or private IP endpoints (fail-closed).
  factory AppEnv.prod({
    required String apiBaseUrl,
    bool enableLogging = false,
    bool enableCertificatePinning = true,
  }) {
    _validateProductionEndpoint(apiBaseUrl);
    return AppEnv._(
      environment: EnvironmentType.prod,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      enableCertificatePinning: enableCertificatePinning,
    );
  }

  /// Enforces fail-closed security for production endpoints.
  static void _validateProductionEndpoint(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.scheme.toLowerCase() != 'https') {
      throw ArgumentError(
        'SECURITY VIOLATION: Production endpoints must strictly use TLS (https://). '
        'Insecure scheme detected in: "$url"',
      );
    }

    final host = uri.host.toLowerCase();
    // Block localhost and private/loopback IP ranges
    if (host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '::1' ||
        host.startsWith('10.') ||
        host.startsWith('192.168.') ||
        _isPrivate172(host)) {
      throw ArgumentError(
        'SECURITY VIOLATION: Production endpoints cannot use localhost or private IP addresses ($host). '
        'Enforcing fail-closed enterprise security policy.',
      );
    }
  }

  static bool _isPrivate172(String host) {
    if (!host.startsWith('172.')) return false;
    final parts = host.split('.');
    if (parts.length < 2) return false;
    final secondOctet = int.tryParse(parts[1]);
    return secondOctet != null && secondOctet >= 16 && secondOctet <= 31;
  }

  bool get isProduction => environment == EnvironmentType.prod;
  bool get isStaging => environment == EnvironmentType.staging;
  bool get isDevelopment => environment == EnvironmentType.dev;
}
