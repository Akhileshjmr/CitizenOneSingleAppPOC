import 'package:equatable/equatable.dart';
import '../../domain/entities/loan_entity.dart';

abstract class LoanState extends Equatable {
  const LoanState();

  @override
  List<Object?> get props => [];
}

class LoanInitial extends LoanState {
  const LoanInitial();
}

class LoanLoading extends LoanState {
  const LoanLoading();
}

class LoanSuccess extends LoanState {
  final LoanEntity loan;

  const LoanSuccess(this.loan);

  @override
  List<Object?> get props => [loan];
}

class LoanFailure extends LoanState {
  final String message;

  const LoanFailure(this.message);

  @override
  List<Object?> get props => [message];
}
