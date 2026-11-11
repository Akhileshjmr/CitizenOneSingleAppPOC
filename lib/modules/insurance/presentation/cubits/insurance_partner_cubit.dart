import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/insurance_partner_entity.dart';
import '../../domain/usecases/get_insurance_partners_usecase.dart';

abstract class InsurancePartnerState extends Equatable {
  const InsurancePartnerState();
  @override
  List<Object?> get props => [];
}

class InsurancePartnerInitial extends InsurancePartnerState {}

class InsurancePartnerLoading extends InsurancePartnerState {}

class InsurancePartnerLoaded extends InsurancePartnerState {
  final List<InsurancePartnerEntity> partners;
  final List<InsurancePartnerEntity> filteredPartners;
  final InsurancePartnerEntity? selectedPartner;
  final String searchQuery;

  const InsurancePartnerLoaded({
    required this.partners,
    required this.filteredPartners,
    this.selectedPartner,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props =>
      [partners, filteredPartners, selectedPartner, searchQuery];
}

class InsurancePartnerError extends InsurancePartnerState {
  final String message;
  const InsurancePartnerError(this.message);

  @override
  List<Object?> get props => [message];
}

class InsurancePartnerCubit extends Cubit<InsurancePartnerState> {
  final GetInsurancePartnersUseCase getPartnersUseCase;

  InsurancePartnerCubit(this.getPartnersUseCase)
      : super(InsurancePartnerInitial());

  Future<void> loadPartners() async {
    emit(InsurancePartnerLoading());
    try {
      final partners = await getPartnersUseCase();
      emit(InsurancePartnerLoaded(
        partners: partners,
        filteredPartners: partners,
        selectedPartner: partners.isNotEmpty ? partners.first : null,
      ));
    } catch (e) {
      emit(InsurancePartnerError(e.toString()));
    }
  }

  void filterPartners(String query) {
    if (state is InsurancePartnerLoaded) {
      final current = state as InsurancePartnerLoaded;
      final filtered = current.partners.where((p) => p.matches(query)).toList();
      emit(InsurancePartnerLoaded(
        partners: current.partners,
        filteredPartners: filtered,
        selectedPartner: current.selectedPartner,
        searchQuery: query,
      ));
    }
  }

  void selectPartner(InsurancePartnerEntity partner) {
    if (state is InsurancePartnerLoaded) {
      final current = state as InsurancePartnerLoaded;
      emit(InsurancePartnerLoaded(
        partners: current.partners,
        filteredPartners: current.filteredPartners,
        selectedPartner: partner,
        searchQuery: current.searchQuery,
      ));
    }
  }

  void reset() {
    emit(InsurancePartnerInitial());
  }
}

