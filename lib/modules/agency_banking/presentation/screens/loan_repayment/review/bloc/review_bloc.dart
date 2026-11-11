import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(const ReviewState()) {
    on<ReviewSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ReviewSubmitted event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.submitting, clearError: true));

    try {
      final response = await event.onSubmit();
      emit(state.copyWith(status: ReviewStatus.success, response: response));
    } catch (_) {
      emit(state.copyWith(
        status: ReviewStatus.failure,
        errorText: 'Could not submit your payment. Please try again.',
      ));
    }
  }
}
