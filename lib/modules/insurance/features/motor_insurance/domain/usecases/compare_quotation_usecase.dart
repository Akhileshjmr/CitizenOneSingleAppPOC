import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class CompareQuotationParams {
  final String productType;
  final String currency;
  final int duration;
  final String durationType;
  final String startDate;
  final PolicyHolderParams policyHolder;
  final List<VehilceParams> risks;
  final double sumInsured;

  const CompareQuotationParams({
    required this.productType,
    required this.currency,
    required this.duration,
    required this.durationType,
    required this.startDate,
    required this.policyHolder,
    required this.risks,
    required this.sumInsured,
  });
}

class PolicyHolderParams {
  final String type;
  final String name;
  final String phone;
  final String physicalAddress;
  final String email;
  final String idType;
  final String idNumber;

  const PolicyHolderParams({
    required this.type,
    required this.name,
    required this.phone,
    required this.physicalAddress,
    required this.email,
    required this.idType,
    required this.idNumber,
  });
}

class VehilceParams {
  final String? id;
  final String? registrationNumber;
  final String? chassisNumber;
  final String? engineNumber;
  final String? make;
  final String? model;
  final int? yearOfManufacture;
  final String? color;
  final int? seatingCapacity;
  final double? sumInsured;
  final String? riskCategoryId;
  final dynamic riskCategory;

  VehilceParams({
    this.id,
    this.registrationNumber,
    this.chassisNumber,
    this.engineNumber,
    this.make,
    this.model,
    this.yearOfManufacture,
    this.color,
    this.seatingCapacity,
    this.sumInsured,
    this.riskCategoryId,
    this.riskCategory,
  });
}

class CompareQuotationUsecase {
  final MotorInsuranceRepository repository;
  const CompareQuotationUsecase(this.repository);

  Future<Either<Failure, QuotationResponse>> call(
      CompareQuotationParams params) async {
    return repository.compareQuotation(params: params);
  }
}
