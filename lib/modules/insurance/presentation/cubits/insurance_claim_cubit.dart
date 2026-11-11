import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/insurance_claim_entity.dart';
import '../../domain/usecases/submit_claim_usecase.dart';
import '../../domain/repositories/insurance_repository.dart';

abstract class InsuranceClaimState extends Equatable {
  const InsuranceClaimState();
  @override
  List<Object?> get props => [];
}

class InsuranceClaimInitial extends InsuranceClaimState {}

class InsuranceClaimLoading extends InsuranceClaimState {}

class InsuranceClaimsLoaded extends InsuranceClaimState {
  final List<InsuranceClaimEntity> claims;
  const InsuranceClaimsLoaded(this.claims);

  @override
  List<Object?> get props => [claims];
}

class InsuranceClaimSubmissionSuccess extends InsuranceClaimState {
  final InsuranceClaimEntity claim;
  const InsuranceClaimSubmissionSuccess(this.claim);

  @override
  List<Object?> get props => [claim];
}

class InsuranceClaimError extends InsuranceClaimState {
  final String message;
  const InsuranceClaimError(this.message);

  @override
  List<Object?> get props => [message];
}

class InsuranceClaimCubit extends Cubit<InsuranceClaimState> {
  final SubmitClaimUseCase submitClaimUseCase;
  final InsuranceRepository repository;

  InsuranceClaimCubit({
    required this.submitClaimUseCase,
    required this.repository,
  }) : super(InsuranceClaimInitial());

  Future<void> loadClaims() async {
    emit(InsuranceClaimLoading());
    try {
      final claims = await repository.getClaims();
      emit(InsuranceClaimsLoaded(claims));
    } catch (e) {
      emit(InsuranceClaimError(e.toString()));
    }
  }

  Future<void> submitClaim({
    required String policyId,
    required double amount,
    required String description,
  }) async {
    emit(InsuranceClaimLoading());
    try {
      final claim = await submitClaimUseCase(
        policyId: policyId,
        amount: amount,
        description: description,
      );
      emit(InsuranceClaimSubmissionSuccess(claim));
    } catch (e) {
      emit(InsuranceClaimError(e.toString()));
    }
  }

  void reset() {
    emit(InsuranceClaimInitial());
  }
}

