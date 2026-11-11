import 'package:citizenone_app/modules/agency_banking/data/models/LoginQRImage.dart';

abstract class LoginQrEvent {}

class LoginQrSubmitted extends LoginQrEvent {
  final LoginQRImage qrImage;
  LoginQrSubmitted(this.qrImage);
}
