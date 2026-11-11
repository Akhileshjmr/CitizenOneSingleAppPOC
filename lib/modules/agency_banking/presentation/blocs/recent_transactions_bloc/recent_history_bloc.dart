import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/recent_transactions_bloc/recent_history_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/recent_transactions_bloc/recent_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

class RecentHistoryBloc extends Bloc<RecentHistoryEvent, RecentHistoryState> {
  final AuthService authService;

  RecentHistoryBloc(this.authService) : super(RecentHistoryInitial()) {
    on<RecentHistorySubmitted>(_onTRecentHistorySubmitted);
  }
  Future<void> _onTRecentHistorySubmitted(
      RecentHistorySubmitted event, Emitter<RecentHistoryState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(RecentHistoryFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }
    emit(RecentHistoryLoading());

    try {
      final response = await authService.transHistory(event.transHistory);
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(RecentHistorySuccess(
            response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(RecentHistoryFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(RecentHistoryFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(RecentHistoryFailure('An error occurred during the account search'));
    }
  }
}
