import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps "Submit". [onSubmit] performs the actual
/// API call (e.g. initiate the payment / generate a transaction id),
/// injected from outside so this Bloc stays networking-agnostic, same
/// pattern as every other Bloc in this app. Returns the raw response.
class ReviewSubmitted extends ReviewEvent {
  final Future<Map<String, dynamic>> Function() onSubmit;

  const ReviewSubmitted({required this.onSubmit});

  @override
  List<Object?> get props => [onSubmit];
}
