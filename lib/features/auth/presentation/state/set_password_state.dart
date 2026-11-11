import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_password_state.freezed.dart';

/// Distinct UI phases for the change-password flow, in line with
/// SKILL.md §7.
enum SetPasswordStatus { initial, loading, success, failure }

@freezed
class SetPasswordState with _$SetPasswordState {
  const factory SetPasswordState({
    /// Mobile number carried from the login screen so the user
    /// doesn't have to re-type it.
    @Default('') String mobileNumber,

    /// Temporary / old password **entered by the user** in the form.
    ///
    /// This is intentionally distinct from any value passed via the
    /// router's `extra:` payload — the Temporary Password field is
    /// always empty on first render and the user must type it.
    @Default('') String temporaryPassword,

    /// New password entered by the user (in-flight value).
    @Default('') String newPassword,

    /// Confirmation password entered by the user.
    @Default('') String confirmPassword,

    /// Tracks the change-password lifecycle so the UI can show
    /// loading, surface failures, and prevent duplicate submissions.
    @Default(SetPasswordStatus.initial) SetPasswordStatus status,

    /// Holds the latest error message for display.
    String? errorMessage,
  }) = _SetPasswordState;
}
