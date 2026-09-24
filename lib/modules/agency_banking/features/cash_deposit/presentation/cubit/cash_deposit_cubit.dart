import 'package:flutter_bloc/flutter_bloc.dart';
import 'cash_deposit_state.dart';
import '../../domain/usecases/submit_cash_deposit.dart';

class CashDepositCubit extends Cubit<CashDepositState> {
  final SubmitCashDepositUseCase useCase;

  CashDepositCubit(this.useCase) : super(const CashDepositInitial());

  Future<void> submit({
    required String accountNumber,
    required double amount,
    required String depositorName,
  }) async {
    emit(const CashDepositLoading());

    try {
      final result = await useCase(
        accountNumber: accountNumber,
        amount: amount,
        depositorName: depositorName,
      );
      emit(CashDepositSuccess(result));
    } catch (e) {
      emit(CashDepositFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void reset() {
    emit(const CashDepositInitial());
  }
}
