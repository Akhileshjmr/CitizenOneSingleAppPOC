import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/policy_entity.dart';
import '../../domain/usecases/purchase_policy_usecase.dart';

abstract class PolicyPurchaseState extends Equatable {
  const PolicyPurchaseState();
  @override
  List<Object?> get props => [];
}

class PolicyPurchaseInitial extends PolicyPurchaseState {}

class PolicyPurchaseLoading extends PolicyPurchaseState {}

class PolicyPurchaseSuccess extends PolicyPurchaseState {
  final PolicyEntity policy;
  const PolicyPurchaseSuccess(this.policy);

  @override
  List<Object?> get props => [policy];
}

class PolicyPurchaseError extends PolicyPurchaseState {
  final String message;
  const PolicyPurchaseError(this.message);

  @override
  List<Object?> get props => [message];
}

class PolicyPurchaseCubit extends Cubit<PolicyPurchaseState> {
  final PurchasePolicyUseCase purchasePolicyUseCase;

  PolicyPurchaseCubit(this.purchasePolicyUseCase)
      : super(PolicyPurchaseInitial());

  Future<void> purchasePolicy({
    required String planId,
    required String policyName,
    required double premiumAmount,
    required String coverageType,
    required String nomineeName,
    required String nomineeRelation,
  }) async {
    emit(PolicyPurchaseLoading());
    try {
      final policy = await purchasePolicyUseCase(
        planId: planId,
        policyName: policyName,
        premiumAmount: premiumAmount,
        coverageType: coverageType,
        nomineeName: nomineeName,
        nomineeRelation: nomineeRelation,
      );
      emit(PolicyPurchaseSuccess(policy));
    } catch (e) {
      emit(PolicyPurchaseError(e.toString()));
    }
  }

  void reset() {
    emit(PolicyPurchaseInitial());
  }
}

