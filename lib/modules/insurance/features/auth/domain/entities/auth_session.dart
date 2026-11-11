import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.userId,
    required this.token,
    required this.issuedAt,
    required this.rememberMe,
  });

  final String userId;
  final String token;
  final DateTime issuedAt;
  final bool rememberMe;

  @override
  List<Object?> get props => [userId, token, issuedAt, rememberMe];
}
