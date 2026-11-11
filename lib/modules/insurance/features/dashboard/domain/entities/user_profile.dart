// =============================================================================
// UserProfile  —  DOMAIN ENTITY
// -----------------------------------------------------------------------------
// Pure Dart, Flutter-free. Equatable for value-based comparison so BLoCs
// emit deduplicated states.
// =============================================================================

import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  List<Object?> get props => [id, fullName, email, phone, avatarUrl];
}
