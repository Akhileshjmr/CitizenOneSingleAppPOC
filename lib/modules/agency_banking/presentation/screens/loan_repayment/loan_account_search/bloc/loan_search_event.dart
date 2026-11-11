import 'package:equatable/equatable.dart';

abstract class LoanSearchEvent extends Equatable {
  const LoanSearchEvent();

  @override
  List<Object?> get props => [];
}

/// Fired whenever the user edits any field, so the Bloc can clear a
/// previously-shown validation error as soon as they start correcting it.
class LoanSearchFieldEdited extends LoanSearchEvent {
  const LoanSearchFieldEdited();
}

/// Fired when the user taps "Search Account".
///
/// [onValidSearch] is the actual API call / navigation action, injected
/// from outside (the screen) so this Bloc stays free of networking and
/// routing concerns and is easy to unit test in isolation.
class LoanSearchSubmitted extends LoanSearchEvent {
  final Future<void> Function() onValidSearch;

  const LoanSearchSubmitted({required this.onValidSearch});

  @override
  List<Object?> get props => [onValidSearch];
}

/// Resets the form back to its initial idle state (e.g. after navigating
/// away and back, or after a successful search followed by "search again").
class LoanSearchReset extends LoanSearchEvent {
  const LoanSearchReset();
}
