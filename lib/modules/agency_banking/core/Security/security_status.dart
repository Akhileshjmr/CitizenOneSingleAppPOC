class SecurityStatus {
  final bool isSecure;
  final bool isRooted;
  final bool isEmulator;
  final bool isDebugged;
  final bool isFridaDetected;

  SecurityStatus({
    required this.isSecure,
    required this.isRooted,
    required this.isEmulator,
    required this.isDebugged,
    required this.isFridaDetected,
  });
}