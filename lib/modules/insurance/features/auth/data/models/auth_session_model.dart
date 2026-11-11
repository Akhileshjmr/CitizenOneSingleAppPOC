import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.userId,
    required super.token,
    required super.issuedAt,
    required super.rememberMe,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      AuthSessionModel(
        userId: json['userId'] as String,
        token: json['token'] as String,
        issuedAt: DateTime.parse(json['issuedAt'] as String),
        rememberMe: json['rememberMe'] as bool,
      );
}
