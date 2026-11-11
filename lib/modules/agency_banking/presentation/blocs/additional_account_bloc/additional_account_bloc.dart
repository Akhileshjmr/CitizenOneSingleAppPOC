
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';
import 'additional_account_event.dart';
import 'additional_account_state.dart';

class AdditionalAccountBloc extends Bloc<AdditionalAccountEvent, AdditionalAccountState> {
  final AuthService authService;

  AdditionalAccountBloc(this.authService) : super(AdditionalAccountInitial()) {
    on<AdditionalAccountSubmitted>(_onAdditionalAccountSubmitted);
  }

  Future<void> _onAdditionalAccountSubmitted(AdditionalAccountSubmitted event,
      Emitter<AdditionalAccountState> emit) async {
    emit(AdditionalAccountLoading());

    try {
      final response = await authService.additional_account(event.accountRequest);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(AdditionalAccountSuccess(response.resMessage.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(AdditionalAccountFailure(response.resMessage.errorDescription));
      } else {
        // Null response scenario
        emit(AdditionalAccountFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(AdditionalAccountFailure('An error occurred while creating additional account'));
    }
  }
}
