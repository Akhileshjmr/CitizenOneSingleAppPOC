import 'package:citizenone_app/features/common/loans/domain/entities/loan_offer.dart';
import 'package:citizenone_app/features/common/loans/domain/entities/loan_application.dart';

class LoanState {
  final List<LoanOffer> allOffers;
  final List<LoanApplication> applications;
  final List<String> selectedOfferIds;
  final String filterType; // 'all', 'lowest_rate', 'fastest'
  final bool isLoading;

  const LoanState({
    this.allOffers = const [],
    this.applications = const [],
    this.selectedOfferIds = const [],
    this.filterType = 'all',
    this.isLoading = false,
  });

  LoanState copyWith({
    List<LoanOffer>? allOffers,
    List<LoanApplication>? applications,
    List<String>? selectedOfferIds,
    String? filterType,
    bool? isLoading,
  }) {
    return LoanState(
      allOffers: allOffers ?? this.allOffers,
      applications: applications ?? this.applications,
      selectedOfferIds: selectedOfferIds ?? this.selectedOfferIds,
      filterType: filterType ?? this.filterType,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<LoanOffer> get filteredOffers {
    if (filterType == 'lowest_rate') {
      final sorted = List<LoanOffer>.from(allOffers);
      sorted.sort((a, b) => a.interestRate.compareTo(b.interestRate));
      return sorted;
    } else if (filterType == 'fastest') {
      return allOffers.where((offer) => offer.isPreApproved).toList();
    }
    return allOffers;
  }

  List<LoanOffer> get selectedOffers {
    return allOffers.where((offer) => selectedOfferIds.contains(offer.id)).toList();
  }
}
