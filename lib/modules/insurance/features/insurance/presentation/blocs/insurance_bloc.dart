import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/domain/usecases/get_insurance_categories_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  final GetInsuranceCategoriesUseCase getInsuranceCategoriesUseCase;

  InsuranceBloc({required this.getInsuranceCategoriesUseCase}) : super(const InsuranceState()) {
    on<FetchInsuranceCategoriesEvent>(_onFetchCategories);

    on<SelectSortByEvent>((event, emit) {
      emit(state.copyWith(sortBy: event.value));
    });

    on<SelectPremiumRangeEvent>((event, emit) {
      emit(state.copyWith(premiumRange: event.value));
    });

    on<SelectClaimRatioEvent>((event, emit) {
      emit(state.copyWith(claimRatio: event.value));
    });

    on<ResetInsuranceEvent>((event, emit) {
      emit(const InsuranceState());
    });

    on<ChangeTabEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedTab: event.index,
        ),
      );
    });

    on<ToggleComparisonPlan>((event, emit) {
      final current = Set<String>.from(state.selectedPlanIds);

      if (current.contains(event.planId)) {
        current.remove(event.planId);
      } else {
        if (current.length < 4) current.add(event.planId);
      }

      emit(state.copyWith(selectedPlanIds: current));
    });

    on<ClearComparison>((event, emit) {
      emit(const InsuranceState());
    });
  }

  Future<void> _onFetchCategories(
    FetchInsuranceCategoriesEvent event,
    Emitter<InsuranceState> emit,
  ) async {
    emit(state.copyWith(categoriesStatus: InsuranceCategoriesStatus.loading));

    final result = await getInsuranceCategoriesUseCase(
      GetInsuranceCategoriesParams(vendorCode: event.vendorCode),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            categoriesStatus: InsuranceCategoriesStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (categories) {
        emit(
          state.copyWith(
            categoriesStatus: InsuranceCategoriesStatus.loaded,
            categories: categories,
          ),
        );
      },
    );
  }
}

