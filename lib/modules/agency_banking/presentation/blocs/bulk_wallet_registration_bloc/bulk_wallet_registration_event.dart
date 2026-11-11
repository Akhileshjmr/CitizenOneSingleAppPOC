import '../../../data/models/ExcelDataUpload.dart';

abstract class BulkWalletRegistrationEvent {}

class BulkWalletRegistrationSubmitted extends BulkWalletRegistrationEvent {
  final ExcelDataUpload excelDataUpload;
  BulkWalletRegistrationSubmitted(this.excelDataUpload);
}
