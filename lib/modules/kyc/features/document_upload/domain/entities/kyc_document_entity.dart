import 'package:equatable/equatable.dart';

class KycDocumentEntity extends Equatable {
  final String documentId;
  final String documentType;
  final String documentNumber;
  final String status;

  const KycDocumentEntity({
    required this.documentId,
    required this.documentType,
    required this.documentNumber,
    required this.status,
  });

  @override
  List<Object?> get props => [documentId, documentType, documentNumber, status];
}
