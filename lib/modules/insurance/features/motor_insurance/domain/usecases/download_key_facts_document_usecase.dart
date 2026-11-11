import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/key_facts_document_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class DownloadKeyFactsDocumentUseCase {
  final MotorInsuranceRepository repository;

  DownloadKeyFactsDocumentUseCase(this.repository);

  Future<Either<Failure, KeyFactsDocumentEntity>> call(String productId) {
    return repository.downloadKeyFactsDocument(productId: productId);
  }
}
