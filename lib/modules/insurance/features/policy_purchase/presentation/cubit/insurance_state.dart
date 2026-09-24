import 'package:equatable/equatable.dart';
import '../../domain/entities/policy_entity.dart';

abstract class InsuranceState extends Equatable {
  const InsuranceState();

  @override
  List<Object?> get props => [];
}

class InsuranceInitial extends InsuranceState {
  const InsuranceInitial();
}

class InsuranceLoading extends InsuranceState {
  const InsuranceLoading();
}

class InsuranceSuccess extends InsuranceState {
  final PolicyEntity policy;

  const InsuranceSuccess(this.policy);

  @override
  List<Object?> get props => [policy];
}

class InsuranceFailure extends InsuranceState {
  final String message;

  const InsuranceFailure(this.message);

  @override
  List<Object?> get props => [message];
}
