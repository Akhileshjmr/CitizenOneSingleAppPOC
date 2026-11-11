import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/usecases/get_insurance_providers_use_case.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/state/insurance_partner_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsurancePartnerCubit extends Cubit<InsurancePartnerState> {
  final GetInsuranceProvidersUseCase _getInsuranceProviders;

  InsurancePartnerCubit({
    required GetInsuranceProvidersUseCase getInsuranceProviders,
  }) : _getInsuranceProviders = getInsuranceProviders,
       super(const InsurancePartnerState());

  Future<void> loadProviders() async {
    emit(
      state.copyWith(status: InsurancePartnerStatus.loading, clearError: true),
    );
    final result = await _getInsuranceProviders();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InsurancePartnerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (providers) => emit(
        state.copyWith(
          status: InsurancePartnerStatus.loaded,
          providers: providers,
          clearSelection: true,
          clearError: true,
        ),
      ),
    );
  }

  void updateSearch(String value) => emit(state.copyWith(searchQuery: value));

  void selectProvider(InsuranceProvider provider) =>
      emit(state.copyWith(selectedProvider: provider));

  /// The reference behavior: focusing Search immediately clears any
  /// current selection (Continue goes back to disabled) — the user
  /// must explicitly re-select a provider, even if they clear the
  /// search text again afterwards.
  void onSearchFocused() {
    if (state.selectedProvider != null) {
      emit(state.copyWith(clearSelection: true));
    }
  }
}
