import '../../../data/models/CommKycUpload.dart';

abstract class KycUploadEvent {}

class KycUploadSubmitted extends KycUploadEvent
{
  final CommKycUpload kycUpload;
  KycUploadSubmitted(this.kycUpload);
}
