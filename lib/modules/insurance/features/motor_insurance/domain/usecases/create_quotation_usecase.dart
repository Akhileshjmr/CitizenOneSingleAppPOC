import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_quotation_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class CreateQuotationParams {
  final String agentCode;
  final String productId;
  final String? clientId;
  final String startDate;
  final int duration;
  final String policyFor;
  final int quarters;
  final String currency;
  final Risks risks;

  CreateQuotationParams({
    required this.agentCode,
    required this.productId,
    this.clientId,
    required this.startDate,
    required this.duration,
    required this.policyFor,
    required this.quarters,
    required this.currency,
    required this.risks,
  });
}

class Risks {
  final String vehicleId;
  final double sumInsured;

  Risks({required this.vehicleId, required this.sumInsured});
}

class CreateQuotationUseCase {
  final MotorInsuranceRepository repositary;
  const CreateQuotationUseCase(this.repositary);

  Future<Either<Failure, CreateQuotationModel>> call({
    required CreateQuotationParams params,
  }) {
    return repositary.createQuotation(params);
  }
}
