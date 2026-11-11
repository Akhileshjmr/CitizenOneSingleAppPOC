import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:citizenone_app/features/auth/domain/entities/session_entity.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

part 'auth_state.freezed.dart';

/// Distinct UI phases for the login flow, in line with SKILL.md §7.
enum AuthLoginStatus { initial, loading, success, failure }

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(UserRole.citizen) UserRole selectedRole,
    @Default(false) bool isAuthenticated,
    @Default('CitizenOne') String workContext,
    String? selectedPartner,
    IconData? partnerIcon,
    String? partnerType,

    /// Tracks the agent login flow lifecycle so the UI can show
    /// loading, surface failures, and prevent duplicate submissions.
    @Default(AuthLoginStatus.initial) AuthLoginStatus loginStatus,

    /// Holds the latest error message for display.
    String? loginErrorMessage,

    /// Active session details. Populated after a successful login and
    /// also hydrated from local storage when the app starts.
    SessionEntity? session,

    /// True when the most recent successful login signalled that the
    /// agent must change their password before a normal session is
    /// issued. The login screen uses this to route the agent to the
    /// change-password flow instead of the role dashboard.
    ///
    /// Note: this flag is intentionally duplicated at the state level
    /// (it's also available on [session.mustChangePassword]) so the
    /// LoginScreen listener can branch on it without having to read
    /// the optional [session] field.
    @Default(false) bool mustChangePassword,
  }) = _AuthState;
}
