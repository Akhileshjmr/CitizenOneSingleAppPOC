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

  factory ScopedToken.fromJson(Map<String, dynamic> json) {
    return ScopedToken(
      token: json['token'] as String? ?? json['scopedToken'] as String? ?? '',
      targetModule:
          json['targetModule'] as String? ?? json['module'] as String? ?? '',
      issuedAt: json['issuedAt'] != null
          ? DateTime.tryParse(json['issuedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString()) ??
              DateTime.now().add(const Duration(minutes: 15))
          : DateTime.now().add(const Duration(minutes: 15)),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'targetModule': targetModule,
        'issuedAt': issuedAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [token, targetModule, issuedAt, expiresAt];
}
