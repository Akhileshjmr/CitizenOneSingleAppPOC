import '../entities/insurance_claim_entity.dart';
import '../repositories/insurance_repository.dart';

class SubmitClaimUseCase {
  final InsuranceRepository repository;

  SubmitClaimUseCase(this.repository);

  Future<InsuranceClaimEntity> call({
    required String policyId,
    required double amount,
    required String description,
  }) {
    return repository.submitClaim(
      policyId: policyId,
      amount: amount,
      description: description,
    );
  }
}

