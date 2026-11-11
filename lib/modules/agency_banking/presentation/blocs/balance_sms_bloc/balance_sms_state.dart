import '../../../data/models/CommAccountRequest.dart';

abstract class BalanceSmsState {}

class BalanceSmsInitial extends BalanceSmsState {}

class BalanceSmsLoading extends BalanceSmsState {}

class BalanceSmsSuccess extends BalanceSmsState {
  final String message;
  final CommAccountRequest commAccountRequest;
  BalanceSmsSuccess(this.message, this.commAccountRequest);
}

class BalanceSmsFailure extends BalanceSmsState {
  final String error;
  BalanceSmsFailure(this.error);
}
