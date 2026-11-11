import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/insurance_plan_entity.dart';
import '../../domain/usecases/get_insurance_plans_usecase.dart';

abstract class InsurancePlansState extends Equatable {
  const InsurancePlansState();
  @override
  List<Object?> get props => [];
}

class InsurancePlansInitial extends InsurancePlansState {}

class InsurancePlansLoading extends InsurancePlansState {}

class InsurancePlansLoaded extends InsurancePlansState {
  final List<InsurancePlanEntity> plans;
  final InsurancePlanEntity? selectedPlan;
  final List<InsurancePlanEntity> comparedPlans;

  const InsurancePlansLoaded({
    required this.plans,
    this.selectedPlan,
    this.comparedPlans = const [],
  });

  @override
  List<Object?> get props => [plans, selectedPlan, comparedPlans];
}

class InsurancePlansError extends InsurancePlansState {
  final String message;
  const InsurancePlansError(this.message);

  @override
  List<Object?> get props => [message];
}

class InsurancePlansCubit extends Cubit<InsurancePlansState> {
  final GetInsurancePlansUseCase getPlansUseCase;

  InsurancePlansCubit(this.getPlansUseCase) : super(InsurancePlansInitial());

  Future<void> loadPlans({String? categoryCode}) async {
    emit(InsurancePlansLoading());
    try {
      final plans = await getPlansUseCase(categoryCode: categoryCode);
      emit(InsurancePlansLoaded(
        plans: plans,
        selectedPlan: plans.isNotEmpty ? plans.first : null,
      ));
    } catch (e) {
      emit(InsurancePlansError(e.toString()));
    }
  }

  void selectPlan(InsurancePlanEntity plan) {
    if (state is InsurancePlansLoaded) {
      final current = state as InsurancePlansLoaded;
      emit(InsurancePlansLoaded(
        plans: current.plans,
        selectedPlan: plan,
        comparedPlans: current.comparedPlans,
      ));
    }
  }

  void toggleComparison(InsurancePlanEntity plan) {
    if (state is InsurancePlansLoaded) {
      final current = state as InsurancePlansLoaded;
      final exists = current.comparedPlans.any((p) => p.id == plan.id);
      final updated = List<InsurancePlanEntity>.from(current.comparedPlans);
      if (exists) {
        updated.removeWhere((p) => p.id == plan.id);
      } else {
        if (updated.length < 2) {
          updated.add(plan);
        }
      }
      emit(InsurancePlansLoaded(
        plans: current.plans,
        selectedPlan: current.selectedPlan,
        comparedPlans: updated,
      ));
    }
  }

  void reset() {
    emit(InsurancePlansInitial());
  }
}

