// import 'package:ab/presentation/blocs/transaction_history/transaction_history_event.dart';
// import 'package:ab/presentation/blocs/transaction_history/transaction_history_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/services/AuthService.dart';
//
// class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
//   final AuthService authService;
//   TransactionHistoryBloc(this.authService) : super(TransactionHistoryInitial()) {
//     on<TransactionHistorySubmitted>(_onTransactionHistorySubmitted);
//   }
//
//   Future<void> _onTransactionHistorySubmitted(
//       TransactionHistorySubmitted event, Emitter<TransactionHistoryState> emit) async {
//     emit(TransactionHistoryLoading());
//
//     try {
//       final response = await authService.transHistory(event.transHistory);
//
//       // Ensure the response is not null
//       if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
//         // Successful search
//         emit(TransactionHistorySuccess(response.resMessage!.errorDescription,response));
//       } else if (response != null) {
//         // Search failed with error description
//         emit(TransactionHistoryFailure(response.resMessage!.errorDescription));
//       } else {
//         // Null response scenario
//         emit(TransactionHistoryFailure('No data returned from the search'));
//       }
//     } catch (e) {
//       // Error handling during search
//       emit(TransactionHistoryFailure('An error occurred while getting transaction receipt'));
//     }
//   }
// }

import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_history/transaction_history_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_history/transaction_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

/*class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final AuthService authService;

 */ /* TransactionHistoryBloc(this.authService) : super(TransactionHistoryInitial()) {

    on<TransactionHistorySubmitted>(_onTransactionHistorySubmitted);

  }*/ /*
  TransactionHistoryBloc(this.authService)
      : super(TransactionHistoryInitial()) {

    on<TransactionHistorySubmitted>(_onTransactionHistorySubmitted);

    // ADD THIS
    on<TransactionHistoryReset>((event, emit) {
      emit(TransactionHistoryInitial());
    });
  }

  Future<void> _onTransactionHistorySubmitted(TransactionHistorySubmitted event,
      Emitter<TransactionHistoryState> emit) async {
    emit(TransactionHistoryLoading());

    try {
      final response = await authService.transHistory(
          event.transHistory);
      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(TransactionHistorySuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(TransactionHistoryFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(TransactionHistoryFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(TransactionHistoryFailure('An error occurred during the account search'));
    }
  }
}*/
class DashboardTransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final AuthService authService;

  DashboardTransactionHistoryBloc(this.authService)
      : super(TransactionHistoryInitial()) {
    on<TransactionHistorySubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(TransactionHistorySubmitted event,
      Emitter<TransactionHistoryState> emit) async {
    emit(TransactionHistoryLoading());
    try {
      final response = await authService.transHistory(event.transHistory);

      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        emit(TransactionHistorySuccess(
            response.resMessage!.errorDescription, response));
      } else {
        emit(TransactionHistoryFailure(
            response?.resMessage?.errorDescription ?? 'Failed'));
      }
    } catch (_) {
      emit(TransactionHistoryFailure('Dashboard history error'));
    }
  }
}

class HistoryTransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final AuthService authService;

  HistoryTransactionHistoryBloc(this.authService)
      : super(TransactionHistoryInitial()) {
    on<TransactionHistorySubmitted>(_onSubmitted);
    on<TransactionHistoryReset>((e, emit) {
      emit(TransactionHistoryInitial());
    });
  }

  Future<void> _onSubmitted(TransactionHistorySubmitted event,
      Emitter<TransactionHistoryState> emit) async {
    emit(TransactionHistoryLoading());
    try {
      final response = await authService.transHistory(event.transHistory);

      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        emit(TransactionHistorySuccess(
            response.resMessage!.errorDescription, response));
      } else {
        emit(TransactionHistoryFailure(
            response?.resMessage?.errorDescription ?? 'Failed'));
      }
    } catch (_) {
      emit(TransactionHistoryFailure('History search failed'));
    }
  }
}
