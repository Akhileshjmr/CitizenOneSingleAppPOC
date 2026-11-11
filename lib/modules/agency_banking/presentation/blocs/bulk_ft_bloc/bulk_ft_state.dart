import 'package:citizenone_app/modules/agency_banking/data/models/ExcelDataUpload.dart';

abstract class BulkFtState {}

class BulkFtInitial extends BulkFtState {}

class BulkFtLoading extends BulkFtState {}

class BulkFtSuccess extends BulkFtState {
  final String message;
  final ExcelDataUpload excelDataUpload;
  BulkFtSuccess(this.message,this.excelDataUpload);
}

class BulkFtFailure extends BulkFtState {
  final String error;
  BulkFtFailure(this.error);
}
