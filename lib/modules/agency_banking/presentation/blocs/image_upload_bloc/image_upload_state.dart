import 'package:citizenone_app/modules/agency_banking/data/models/CommCustImageSignList.dart';

abstract class CustImageUploadState {}

class CustImageUploadInitial extends CustImageUploadState {}

class CustImageUploadLoading extends CustImageUploadState {}

class CustImageUploadSuccess extends CustImageUploadState {
  final String message;
  final CommCustImageSignList imageSignList;
  CustImageUploadSuccess(this.message, this.imageSignList);
}

class CustImageUploadFailure extends CustImageUploadState {
  final String error;
  CustImageUploadFailure(this.error);
}
