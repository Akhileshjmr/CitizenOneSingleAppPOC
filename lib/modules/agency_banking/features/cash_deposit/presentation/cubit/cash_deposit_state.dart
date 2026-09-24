import 'package:equatable/equatable.dart';
import '../../domain/entities/cash_deposit_entity.dart';

abstract class CashDepositState extends Equatable {
  const CashDepositState();

  @override
  List<Object?> get props => [];
}

class CashDepositInitial extends CashDepositState {
  const CashDepositInitial();
}

class CashDepositLoading extends CashDepositState {
  const CashDepositLoading();
}

class CashDepositSuccess extends CashDepositState {
  final CashDepositEntity result;

  const CashDepositSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class CashDepositFailure extends CashDepositState {
  final String errorMessage;

  const CashDepositFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
