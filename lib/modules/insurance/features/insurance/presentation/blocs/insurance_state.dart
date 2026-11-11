import 'package:citizenone_app/modules/insurance/features/insurance/domain/entities/insurance_category_entity.dart';

enum InsuranceCategoriesStatus { initial, loading, loaded, error }

class InsuranceState {
  final String sortBy;
  final String premiumRange;
  final String claimRatio;
  final int selectedTab;
  final Set<String> selectedPlanIds;
  
  // API Categories state fields
  final InsuranceCategoriesStatus categoriesStatus;
  final List<InsuranceCategoryEntity> categories;
  final String? errorMessage;

  const InsuranceState({
    this.sortBy = 'Popular (Default)',
    this.premiumRange = 'Any Premium',
    this.claimRatio = 'Any Ratio',
    this.selectedTab = 0,
    this.selectedPlanIds = const {},
    this.categoriesStatus = InsuranceCategoriesStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  bool isSelected(String planId) => selectedPlanIds.contains(planId);
  int get count => selectedPlanIds.length;
  bool get canCompare => selectedPlanIds.length >= 2;

  InsuranceState copyWith({
    String? sortBy,
    String? premiumRange,
    String? claimRatio,
    int? selectedTab,
    Set<String>? selectedPlanIds,
    InsuranceCategoriesStatus? categoriesStatus,
    List<InsuranceCategoryEntity>? categories,
    String? errorMessage,
  }) {
    return InsuranceState(
      sortBy: sortBy ?? this.sortBy,
      premiumRange: premiumRange ?? this.premiumRange,
      claimRatio: claimRatio ?? this.claimRatio,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedPlanIds: selectedPlanIds ?? this.selectedPlanIds,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

