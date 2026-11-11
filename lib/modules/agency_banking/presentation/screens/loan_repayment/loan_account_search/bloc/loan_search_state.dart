import 'package:equatable/equatable.dart';

enum LoanSearchStatus { idle, submitting, success, failure }

/// Immutable state for the Loan Account Search screen.
///
/// Note: the three text fields themselves are NOT kept in this state.
/// They're owned by [TextEditingController]s that live alongside the
/// Bloc (see [LoanSearchBloc]) — putting live keystroke text into Bloc
/// state would emit on every keypress and rebuild the whole subtree.
/// Only the *derived* things (status, error message) belong in state.
class LoanSearchState extends Equatable {
  final LoanSearchStatus status;
  final String? errorText;

  const LoanSearchState({
    this.status = LoanSearchStatus.idle,
    this.errorText,
  });

  bool get isSubmitting => status == LoanSearchStatus.submitting;

  LoanSearchState copyWith({
    LoanSearchStatus? status,
    String? errorText,
    bool clearError = false,
  }) {
    return LoanSearchState(
      status: status ?? this.status,
      errorText: clearError ? null : (errorText ?? this.errorText),
    );
  }

  @override
  List<Object?> get props => [status, errorText];
}
