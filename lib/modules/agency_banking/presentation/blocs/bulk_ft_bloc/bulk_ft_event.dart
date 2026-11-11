import 'package:citizenone_app/modules/agency_banking/data/models/ExcelDataUpload.dart';

abstract class BulkFtEvent {}

class BulkFtSubmitted extends BulkFtEvent {
  final ExcelDataUpload excelDataUpload;
  BulkFtSubmitted(this.excelDataUpload);
}