import 'package:equatable/equatable.dart';

/// Represents a short-lived scoped JWT token issued for a specific business vertical.
/// Fulfills Section 5 (Enterprise Security Seams & Scoped Token Exchange).
class ScopedToken extends Equatable {
  final String token;
  final String targetModule;
  final DateTime issuedAt;
  final DateTime expiresAt;

  const ScopedToken({
    required this.token,
    required this.targetModule,
    required this.issuedAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [token, targetModule, issuedAt, expiresAt];
}
