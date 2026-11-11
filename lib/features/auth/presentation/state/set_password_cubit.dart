import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/change_password_usecase.dart';
import 'set_password_state.dart';

class SetPasswordCubit extends Cubit<SetPasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  SetPasswordCubit({
    required ChangePasswordUseCase changePasswordUseCase,
    String mobileNumber = '',
    // The router may still pass a `currentPassword` for comparison
    // or other business logic, but it is no longer used to prefill
    // the Temporary Password field. The field is always empty on
    // first render and the user must type it.
    // ignore: unused_element_parameter
    String currentPassword = '',
  }) : _changePasswordUseCase = changePasswordUseCase,
       super(SetPasswordState(mobileNumber: mobileNumber));

  void setTemporaryPassword(String value) {
    emit(state.copyWith(temporaryPassword: value, errorMessage: null));
  }

  void setNewPassword(String value) {
    emit(state.copyWith(newPassword: value, errorMessage: null));
  }

  void setConfirmPassword(String value) {
    emit(state.copyWith(confirmPassword: value, errorMessage: null));
  }

  /// Returns true when all five validation rules pass.
  ///
  /// Rules (matched against the reference image requirements):
  /// - Temporary password required.
  /// - New password required and ≥ 8 chars.
  /// - New password must differ from the temporary password.
  /// - Confirm password required.
  /// - Confirm password must equal the new password.
  bool isFormValid(
    String l10nTempRequired,
    String l10nNewRequired,
    String l10nNewTooShort,
    String l10nNewSameAsTemp,
    String l10nConfirmRequired,
    String l10nConfirmMismatch,
  ) {
    final tempPwd = state.temporaryPassword;
    final newPwd = state.newPassword;
    final confirmPwd = state.confirmPassword;

    if (tempPwd.isEmpty) {
      _emitFailure(l10nTempRequired);
      return false;
    }
    if (newPwd.isEmpty) {
      _emitFailure(l10nNewRequired);
      return false;
    }
    if (newPwd.length < 8) {
      _emitFailure(l10nNewTooShort);
      return false;
    }
    if (newPwd == tempPwd) {
      _emitFailure(l10nNewSameAsTemp);
      return false;
    }
    if (confirmPwd.isEmpty) {
      _emitFailure(l10nConfirmRequired);
      return false;
    }
    if (confirmPwd != newPwd) {
      _emitFailure(l10nConfirmMismatch);
      return false;
    }
    return true;
  }

  void _emitFailure(String message) {
    if (state.status == SetPasswordStatus.failure &&
        state.errorMessage == message) {
      return;
    }
    emit(
      state.copyWith(status: SetPasswordStatus.failure, errorMessage: message),
    );
  }

  void clearError() {
    if (state.errorMessage == null &&
        state.status != SetPasswordStatus.loading) {
      return;
    }
    emit(state.copyWith(status: SetPasswordStatus.initial, errorMessage: null));
  }

  /// Submits the change-password request. Emits `loading` then either
  /// `success` or `failure`. Re-entrant calls are blocked while a
  /// request is in flight.
  ///
  /// The temporary password used in the API call is the one the user
  /// entered in the form (stored in [SetPasswordState.temporaryPassword]),
  /// not any value passed in via the router.
  Future<void> submit({
    required String validationTempRequired,
    required String validationNewRequired,
    required String validationNewTooShort,
    required String validationNewSameAsTemp,
    required String validationConfirmRequired,
    required String validationConfirmMismatch,
  }) async {
    if (state.status == SetPasswordStatus.loading) {
      return;
    }

    final isValid = isFormValid(
      validationTempRequired,
      validationNewRequired,
      validationNewTooShort,
      validationNewSameAsTemp,
      validationConfirmRequired,
      validationConfirmMismatch,
    );
    if (!isValid) return;

    emit(state.copyWith(status: SetPasswordStatus.loading, errorMessage: null));

    final result = await _changePasswordUseCase(
      mobileNumber: state.mobileNumber,
      currentPassword: state.temporaryPassword,
      newPassword: state.newPassword,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SetPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(status: SetPasswordStatus.success, errorMessage: null),
      ),
    );
  }
}
