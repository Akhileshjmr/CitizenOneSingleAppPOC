

import 'package:citizenone_app/modules/agency_banking/data/models/CommRequestList.dart';

abstract class ReceiveRequestState {}

class ReceiveRequestInitial extends ReceiveRequestState {}

class ReceiveRequestLoading extends ReceiveRequestState {}

class ReceiveRequestSuccess extends ReceiveRequestState {
  final String message;
  final CommRequestList receiveRequest;
  ReceiveRequestSuccess(this.message,this.receiveRequest);
}

class ReceiveRequestFailure extends ReceiveRequestState {
  final String error;
  ReceiveRequestFailure(this.error);
}
