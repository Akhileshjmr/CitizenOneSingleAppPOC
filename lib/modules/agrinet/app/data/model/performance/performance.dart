import '../common/ch_message.dart';

class PerformanceSummary {
  String? reqSecureKey;
  String? addiParams;
  ChMessage? chMessage;
  String? urlDecision;

  int? farmersOnboarded;
  int? groupsCreated;
  int? serviceRequestsRaised;
  int? noOfFarmingPlansCreated;
  int? noOfAdsPublished;
  int? noOfFarmPlansBankApproved;
  int? noOfBidAccepted;
  int? noOfBuyerPaymentReceived;

  PerformanceSummary({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.farmersOnboarded,
    this.groupsCreated,
    this.serviceRequestsRaised,
    this.noOfFarmingPlansCreated,
    this.noOfAdsPublished,
    this.noOfFarmPlansBankApproved,
    this.noOfBidAccepted,
    this.noOfBuyerPaymentReceived,
  });

  factory PerformanceSummary.fromJson(Map<String, dynamic> json) {
    return PerformanceSummary(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      urlDecision: json['urlDecision'],

      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,

      farmersOnboarded: json['farmersOnboarded'] ?? 0,
      groupsCreated: json['groupsCreated'] ?? 0,
      serviceRequestsRaised: json['serviceRequestsRaised'] ?? 0,
      noOfFarmingPlansCreated: json['noOfFarmingPlansCreated'] ?? 0,
      noOfAdsPublished: json['noOfAdsPublished'] ?? 0,
      noOfFarmPlansBankApproved: json['noOfFarmPlansBankApproved'] ?? 0,
      noOfBidAccepted: json['noOfBidAccepted'] ?? 0,
      noOfBuyerPaymentReceived: json['noOfBuyerPaymentReceived'] ?? 0,
    );
  }
}
