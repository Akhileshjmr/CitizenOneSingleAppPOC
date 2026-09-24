import '../api/kyc_api.dart';
import '../../domain/entities/kyc_document_entity.dart';

abstract class KycRepository {
  Future<KycDocumentEntity> uploadDocument({
    required String type,
    required String number,
  });
}

class KycRepositoryImpl implements KycRepository {
  final KycApi api;

  KycRepositoryImpl(this.api);

  @override
  Future<KycDocumentEntity> uploadDocument({
    required String type,
    required String number,
  }) async {
    return await api.uploadDocument(type: type, number: number);
  }
}
