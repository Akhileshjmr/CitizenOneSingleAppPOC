import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/policy_entity.dart';
import '../../domain/usecases/get_active_policies_usecase.dart';

abstract class ActivePoliciesState extends Equatable {
  const ActivePoliciesState();
  @override
  List<Object?> get props => [];
}

class ActivePoliciesInitial extends ActivePoliciesState {}

class ActivePoliciesLoading extends ActivePoliciesState {}

class ActivePoliciesLoaded extends ActivePoliciesState {
  final List<PolicyEntity> policies;
  const ActivePoliciesLoaded(this.policies);

  @override
  List<Object?> get props => [policies];
}

class ActivePoliciesError extends ActivePoliciesState {
  final String message;
  const ActivePoliciesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ActivePoliciesCubit extends Cubit<ActivePoliciesState> {
  final GetActivePoliciesUseCase getActivePoliciesUseCase;

  ActivePoliciesCubit(this.getActivePoliciesUseCase)
      : super(ActivePoliciesInitial());

  Future<void> loadPolicies() async {
    emit(ActivePoliciesLoading());
    try {
      final policies = await getActivePoliciesUseCase();
      emit(ActivePoliciesLoaded(policies));
    } catch (e) {
      emit(ActivePoliciesError(e.toString()));
    }
  }

  void addPurchasedPolicy(PolicyEntity policy) {
    if (state is ActivePoliciesLoaded) {
      final current = (state as ActivePoliciesLoaded).policies;
      emit(ActivePoliciesLoaded([policy, ...current]));
    } else {
      emit(ActivePoliciesLoaded([policy]));
    }
  }

  void reset() {
    emit(ActivePoliciesInitial());
  }
}

