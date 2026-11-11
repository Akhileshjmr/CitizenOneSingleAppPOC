import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';

enum InsurancePartnerStatus { initial, loading, loaded, failure }

class InsurancePartnerState {
  final InsurancePartnerStatus status;
  final List<InsuranceProvider> providers;
  final InsuranceProvider? selectedProvider;
  final String searchQuery;
  final String? errorMessage;

  const InsurancePartnerState({
    this.status = InsurancePartnerStatus.initial,
    this.providers = const [],
    this.selectedProvider,
    this.searchQuery = '',
    this.errorMessage,
  });

  List<InsuranceProvider> get filteredProviders =>
      providers.where((provider) => provider.matches(searchQuery)).toList();

  InsurancePartnerState copyWith({
    InsurancePartnerStatus? status,
    List<InsuranceProvider>? providers,
    InsuranceProvider? selectedProvider,
    bool clearSelection = false,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) => InsurancePartnerState(
    status: status ?? this.status,
    providers: providers ?? this.providers,
    selectedProvider: clearSelection
        ? null
        : selectedProvider ?? this.selectedProvider,
    searchQuery: searchQuery ?? this.searchQuery,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
