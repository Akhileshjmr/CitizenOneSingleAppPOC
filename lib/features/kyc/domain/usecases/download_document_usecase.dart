
import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../repositories/kyc_repository.dart';

class DownloadDocumentParams {
  final String url;
  final String fileName;

  const DownloadDocumentParams({required this.url, required this.fileName});
}

class DownloadDocumentUseCase {
  final KycRepository repository;

  DownloadDocumentUseCase(this.repository);

  Future<Either<Failure, bool>> call(DownloadDocumentParams params) {
    return repository.downloadDocument(
      url: params.url,
      fileName: params.fileName,
    );
  }
}
