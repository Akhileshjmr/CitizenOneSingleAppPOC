import 'package:citizenone_app/modules/agency_banking/data/models/LoginQRImage.dart';

abstract class LoginQrState {}

class LoginQrInitial extends LoginQrState {}

class LoginQrLoading extends LoginQrState {}

class LoginQrSuccess extends LoginQrState {
  final String message;
  final LoginQRImage qrImage;
  LoginQrSuccess(this.message, this.qrImage);
}

class LoginQrFailure extends LoginQrState {
  final String error;
  LoginQrFailure(this.error);
}
