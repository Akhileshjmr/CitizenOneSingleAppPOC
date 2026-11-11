import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/common/loans/domain/usecases/get_loan_offers_usecase.dart';
import 'package:citizenone_app/features/common/loans/domain/usecases/get_loan_applications_usecase.dart';
import 'package:citizenone_app/features/common/loans/presentation/state/loan_state.dart';

class LoanCubit extends Cubit<LoanState> {
  final GetLoanOffersUseCase _offersUseCase;
  final GetLoanApplicationsUseCase _applicationsUseCase;

  LoanCubit({
    required GetLoanOffersUseCase offersUseCase,
    required GetLoanApplicationsUseCase applicationsUseCase,
  })  : _offersUseCase = offersUseCase,
        _applicationsUseCase = applicationsUseCase,
        super(const LoanState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final offers = await _offersUseCase();
      final apps = await _applicationsUseCase();
      emit(state.copyWith(
        allOffers: offers,
        applications: apps,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error appropriately
    }
  }

  void setFilter(String filterType) {
    emit(state.copyWith(filterType: filterType));
  }

  void toggleOfferSelection(String offerId) {
    final selected = List<String>.from(state.selectedOfferIds);
    if (selected.contains(offerId)) {
      selected.remove(offerId);
    } else {
      selected.add(offerId);
    }
    emit(state.copyWith(selectedOfferIds: selected));
  }

  void clearSelection() {
    emit(state.copyWith(selectedOfferIds: []));
  }
}
