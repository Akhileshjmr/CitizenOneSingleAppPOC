import 'package:flutter_bloc/flutter_bloc.dart';
import 'insurance_state.dart';
import '../../domain/usecases/purchase_policy.dart';

class InsuranceCubit extends Cubit<InsuranceState> {
  final PurchasePolicyUseCase purchaseUseCase;

  InsuranceCubit(this.purchaseUseCase) : super(const InsuranceInitial());

  Future<void> purchase({
    required String policyName,
    required double premiumAmount,
  }) async {
    emit(const InsuranceLoading());
    try {
      final policy = await purchaseUseCase(
        policyName: policyName,
        premiumAmount: premiumAmount,
      );
      emit(InsuranceSuccess(policy));
    } catch (e) {
      emit(InsuranceFailure(e.toString()));
    }
  }

  void reset() {
    emit(const InsuranceInitial());
  }
}
