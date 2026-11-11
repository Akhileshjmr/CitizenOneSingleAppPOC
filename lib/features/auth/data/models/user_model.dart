import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

/// User data transfer model for the data layer.
class UserModel {
  final String id;
  final String username;
  final UserRole role;
  final bool isAuthenticated;

  const UserModel({
    required this.id,
    required this.username,
    required this.role,
    this.isAuthenticated = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'role': role.name,
        'isAuthenticated': isAuthenticated,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        username: json['username'] as String,
        role: UserRole.values.firstWhere((r) => r.name == json['role']),
        isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      );
}
