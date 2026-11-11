import '../../../data/models/CommKycUpload.dart';

abstract class KycUploadState {}

class KycUploadInitial extends KycUploadState {}

class KycUploadLoading extends KycUploadState {}

class KycUploadSuccess extends KycUploadState {
  final CommKycUpload user;
  final String responseMessage;
  final String responseCode;
  KycUploadSuccess(this.user, this.responseMessage, this.responseCode);
}

class KycUploadFailure extends KycUploadState {
  final String error;
  KycUploadFailure(this.error);
}