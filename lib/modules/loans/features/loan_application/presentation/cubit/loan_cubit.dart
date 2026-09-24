import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_state.dart';
import '../../domain/usecases/apply_for_loan.dart';

class LoanCubit extends Cubit<LoanState> {
  final ApplyForLoanUseCase applyUseCase;

  LoanCubit(this.applyUseCase) : super(const LoanInitial());

  Future<void> submitLoanApplication({
    required double amount,
    required int tenureMonths,
  }) async {
    emit(const LoanLoading());
    try {
      final result =
          await applyUseCase(amount: amount, tenureMonths: tenureMonths);
      emit(LoanSuccess(result));
    } catch (e) {
      emit(LoanFailure(e.toString()));
    }
  }

  void reset() {
    emit(const LoanInitial());
  }
}
