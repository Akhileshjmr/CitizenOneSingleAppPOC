import '../../data/repository/kyc_repository.dart';
import '../entities/kyc_document_entity.dart';

class UploadKycDocumentUseCase {
  final KycRepository repository;

  UploadKycDocumentUseCase(this.repository);

  Future<KycDocumentEntity> call({
    required String type,
    required String number,
  }) {
    if (number.trim().isEmpty) {
      throw ArgumentError('Document number cannot be empty');
    }
    return repository.uploadDocument(type: type, number: number);
  }
}
