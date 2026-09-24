import '../../domain/entities/kyc_document_entity.dart';

class KycDocumentModel extends KycDocumentEntity {
  const KycDocumentModel({
    required super.documentId,
    required super.documentType,
    required super.documentNumber,
    required super.status,
  });

  factory KycDocumentModel.fromJson(Map<String, dynamic> json) {
    return KycDocumentModel(
      documentId: json['documentId'] as String? ??
          'DOC-${DateTime.now().millisecondsSinceEpoch}',
      documentType: json['documentType'] as String? ?? 'NATIONAL_ID',
      documentNumber: json['documentNumber'] as String? ?? '',
      status: json['status'] as String? ?? 'VERIFIED',
    );
  }
}
