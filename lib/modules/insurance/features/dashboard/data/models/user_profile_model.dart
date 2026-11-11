// =============================================================================
// UserProfileModel  —  DATA LAYER
// -----------------------------------------------------------------------------
// Extends the domain entity for ergonomics; in stricter setups you'd keep
// the model fully separate. Adds (de)serialization + toEntity() so the
// domain remains pure.
// =============================================================================

import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    super.avatarUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        avatarUrl: json['avatarUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'avatarUrl': avatarUrl,
      };
}
