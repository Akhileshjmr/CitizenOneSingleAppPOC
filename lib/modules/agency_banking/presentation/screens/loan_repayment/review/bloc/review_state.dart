import 'package:equatable/equatable.dart';

enum ReviewStatus { idle, submitting, success, failure }

class ReviewState extends Equatable {
  final ReviewStatus status;
  final String? errorText;
  final Map<String, dynamic>? response;

  const ReviewState({
    this.status = ReviewStatus.idle,
    this.errorText,
    this.response,
  });

  bool get isSubmitting => status == ReviewStatus.submitting;

  ReviewState copyWith({
    ReviewStatus? status,
    String? errorText,
    bool clearError = false,
    Map<String, dynamic>? response,
  }) {
    return ReviewState(
      status: status ?? this.status,
      errorText: clearError ? null : (errorText ?? this.errorText),
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [status, errorText, response];
}
