import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/instant_issue_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class CreateInstantIssueParams {
  final String productId;
  final int duration;
  final String currency;
  final String startDate;
  final String agentCode;
  final PolicyHolderInstantParams policyHolder;
  final List<InstantRiskParams> risks;
  final String? reference;

  CreateInstantIssueParams({
    required this.productId,
    required this.duration,
    required this.currency,
    required this.startDate,
    required this.agentCode,
    required this.policyHolder,
    required this.risks,
    this.reference,
  });
}

class PolicyHolderInstantParams {
  final String type;
  final String name;
  final String phone;
  final String email;
  final String physicalAddress;
  final String idType;
  final String idNumber;
  final String tpinNumber;

  PolicyHolderInstantParams({
    required this.type,
    required this.name,
    required this.phone,
    required this.email,
    required this.physicalAddress,
    required this.idType,
    required this.idNumber,
    required this.tpinNumber,
  });
}

class InstantRiskParams {
  final String make;
  final String model;
  final int yearOfManufacture;
  final String registrationNumber;
  final String chassisNumber;
  final String engineNumber;
  final double sumInsured;
  final String currency;
  final String color;
  final String motorRiskCategoryId;
  final String? motorBodyTypeId;

  InstantRiskParams({
    required this.make,
    required this.model,
    required this.yearOfManufacture,
    required this.registrationNumber,
    required this.chassisNumber,
    required this.engineNumber,
    required this.sumInsured,
    required this.currency,
    required this.color,
    required this.motorRiskCategoryId,
    this.motorBodyTypeId,
  });
}

class RiskInstantParams {
  final String make;
  final String model;
  final int yearOfManufacture;
  final String registrationNumber;
  final String chassisNumber;
  final String engineNumber;
  final double sumInsured;
  final String currency;
  final String color;
  final String motorRiskCategoryId;
  final String motorBodyTypeId;

  RiskInstantParams({
    required this.make,
    required this.model,
    required this.yearOfManufacture,
    required this.registrationNumber,
    required this.chassisNumber,
    required this.engineNumber,
    required this.sumInsured,
    required this.currency,
    required this.color,
    required this.motorRiskCategoryId,
    required this.motorBodyTypeId,
  });
}

class CreateInstantIssueUseCase {
  final MotorInsuranceRepository repository;

  CreateInstantIssueUseCase(this.repository);

  Future<Either<Failure, InstantIssueResponse>> call(
      CreateInstantIssueParams params) async {
    return await repository.createInstantIssue(params);
  }
}
