import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String token;
  final List<String> roles;

  const UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.token,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String? ?? 'USR-1001',
      username: json['username'] as String? ?? 'citizen_user',
      email: json['email'] as String? ?? 'user@citizenone.gov',
      token: json['token'] as String? ?? 'mock-jwt-token',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['CITIZEN'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'email': email,
        'token': token,
        'roles': roles,
      };

  @override
  List<Object?> get props => [userId, username, email, token, roles];
}
