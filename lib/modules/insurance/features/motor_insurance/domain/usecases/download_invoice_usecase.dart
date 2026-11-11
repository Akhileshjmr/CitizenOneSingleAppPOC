import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class DownloadInvoiceParams {
  final String policyId;


  const DownloadInvoiceParams(
      {required this.policyId});
}

class DownloadInvoiceUseCase {
  final MotorInsuranceRepository repository;

  DownloadInvoiceUseCase(this.repository);

  Future<Either<Failure, bool>> call(DownloadInvoiceParams params) {
    return repository.downloadInvoice(params: params);
  }
}
