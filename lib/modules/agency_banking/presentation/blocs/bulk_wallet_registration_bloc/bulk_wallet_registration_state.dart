import '../../../data/models/ExcelDataUpload.dart';

abstract class BulkWalletRegistrationState {}

class BulkWalletRegistrationInitial extends BulkWalletRegistrationState {}

class BulkWalletRegistrationLoading extends BulkWalletRegistrationState {}

class BulkWalletRegistrationSuccess extends BulkWalletRegistrationState {
  final String message;
  final ExcelDataUpload excelDataUpload;
  BulkWalletRegistrationSuccess(this.message,this.excelDataUpload);
}

class BulkWalletRegistrationFailure extends BulkWalletRegistrationState {
  final String error;
  BulkWalletRegistrationFailure(this.error);
}
