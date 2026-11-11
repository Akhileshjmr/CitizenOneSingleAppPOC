import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/common_models/AbFcErrorType.dart';
import '../../../data/services/AuthService.dart';
import 'account_search_event.dart';
import 'account_search_state.dart';

class AccountSearchBloc extends Bloc<AccountSearchEvent, AccountSearchState> {
  final AuthService authService;

  AccountSearchBloc(this.authService) : super(AccountSearchInitial()) {
    on<AccountSearchSubmitted>(_onAccountSearchSubmitted);
  }

  Future<void> _onAccountSearchSubmitted(
      AccountSearchSubmitted event, Emitter<AccountSearchState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(AccountSearchFailure(
          "You're offline. Please check your internet connection and try again.",
          null));
      return;
    }
    emit(AccountSearchLoading());

    try {
      final response =
          await authService.accountSearch(event.accountSearchRequest);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(AccountSearchSuccess(response.resMessage.errorDescription,
            response, response.resMessage.fcError));
      } else if (response != null) {
        // Search failed with error description
        emit(AccountSearchFailure(
            response.resMessage.errorDescription, response.resMessage.fcError));
      } else {
        // Null response scenario
        emit(AccountSearchFailure(
            'No data returned from the search', '' as List<AbFcErrorType>?));
      }
    } catch (e) {
      // Error handling during search
      emit(AccountSearchFailure('An error occurred during the account search',
          '' as List<AbFcErrorType>?));
    }
  }
}
