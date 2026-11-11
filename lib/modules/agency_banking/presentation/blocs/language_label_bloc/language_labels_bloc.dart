
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';
import 'language_labels_event.dart';
import 'language_labels_state.dart';

class LanguageLabelsBloc extends Bloc<LanguageLabelsEvent, LanguageLabelsState> {
  final AuthService authService;
  LanguageLabelsBloc(this.authService) : super(LanguageLabelsInitial()) {
    on<LanguageLabelsSubmitted>(_onLanguageLabelsSubmitted);
  }

  Future<void> _onLanguageLabelsSubmitted(
      LanguageLabelsSubmitted event, Emitter<LanguageLabelsState> emit) async {
    emit(LanguageLabelsLoading());

    try {
      final response = await authService.get_language_labels(event.commLanguageLabels);
      // Ensure the response is not null
      if (response != null && response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(LanguageLabelsSuccess(response.resMessage.errorDescription,response));

      } else if (response != null) {
        // Search failed with error description
        emit(LanguageLabelsFailure(response.resMessage.errorDescription));

      } else {
        // Null response scenario
        emit(LanguageLabelsFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(LanguageLabelsFailure('An error occurred during the account search'));
    }
  }
}