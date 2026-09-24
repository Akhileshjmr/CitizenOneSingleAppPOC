import 'package:equatable/equatable.dart';
import '../../domain/entities/citizen_service_entity.dart';

abstract class CitizenState extends Equatable {
  const CitizenState();

  @override
  List<Object?> get props => [];
}

class CitizenInitial extends CitizenState {
  const CitizenInitial();
}

class CitizenLoading extends CitizenState {
  const CitizenLoading();
}

class CitizenLoaded extends CitizenState {
  final List<CitizenServiceEntity> services;

  const CitizenLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class CitizenFailure extends CitizenState {
  final String message;

  const CitizenFailure(this.message);

  @override
  List<Object?> get props => [message];
}
