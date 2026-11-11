abstract class InsuranceEvent {}

class SelectSortByEvent extends InsuranceEvent {
  final String value;

  SelectSortByEvent(this.value);
}

class SelectPremiumRangeEvent extends InsuranceEvent {
  final String value;

  SelectPremiumRangeEvent(this.value);
}

class SelectClaimRatioEvent extends InsuranceEvent {
  final String value;

  SelectClaimRatioEvent(this.value);
}

class ResetInsuranceEvent extends InsuranceEvent {}


class ChangeTabEvent extends InsuranceEvent {
  final int index;

  ChangeTabEvent(this.index);
}
class ToggleComparisonPlan extends InsuranceEvent {
  final String planId;
  ToggleComparisonPlan(this.planId);
}

class ClearComparison extends InsuranceEvent {}

class FetchInsuranceCategoriesEvent extends InsuranceEvent {
  final String vendorCode;
  FetchInsuranceCategoriesEvent({required this.vendorCode});
}

