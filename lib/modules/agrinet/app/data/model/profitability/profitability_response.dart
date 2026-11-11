import '../common/ch_message.dart';

class ProfitabilityResponse {
  final ChMessage chMessage;
  final FarmPlanProfit? farmPlanProfit;

  ProfitabilityResponse({
    required this.chMessage,
    required this.farmPlanProfit,
  });

  factory ProfitabilityResponse.fromJson(Map<String, dynamic> json) {
    return ProfitabilityResponse(
      chMessage: ChMessage.fromJson(json["chMessage"] ?? {}),
      farmPlanProfit:
          json["farmPlanProfi"] != null
              ? FarmPlanProfit.fromJson(json["farmPlanProfi"])
              : null,
    );
  }
}

class FarmPlanProfit {
  final String estCost;
  final String estYield;
  final String estYieldValue;
  final String actCost;
  final String actYield;
  final String actYieldValue;
  final String saleValue;
  final String profitOrLoss;
  final FarmerGroupProfit farmerGroupProfit;

  FarmPlanProfit({
    required this.estCost,
    required this.estYield,
    required this.estYieldValue,
    required this.actCost,
    required this.actYield,
    required this.actYieldValue,
    required this.saleValue,
    required this.profitOrLoss,
    required this.farmerGroupProfit,
  });

  factory FarmPlanProfit.fromJson(Map<String, dynamic> json) {
    return FarmPlanProfit(
      estCost: json["estCostOfProject"],
      estYield: json["estYieldPerAcer"],
      estYieldValue: json["estYieldValue"],
      actCost: json["actCostOfProject"],
      actYield: json["actYieldPerAcer"],
      actYieldValue: json["actYieldValue"],
      saleValue: json["saleValue"],
      profitOrLoss: json["profitOrLoss"],
      farmerGroupProfit: FarmerGroupProfit.fromJson(json["farmerGroupProfi"]),
    );
  }
}

class FarmerGroupProfit {
  final String farmPlanId;
  final String saleValue;
  final String outstandingLoanAmount;
  final String vendorPayments;
  final String palCommission;
  final String balanceToGroup;
  final List<FarmerProfitDetails> farmerDetails;

  FarmerGroupProfit({
    required this.farmPlanId,
    required this.saleValue,
    required this.outstandingLoanAmount,
    required this.vendorPayments,
    required this.palCommission,
    required this.balanceToGroup,
    required this.farmerDetails,
  });

  factory FarmerGroupProfit.fromJson(Map<String, dynamic> json) {
    final list = json["farmerProfiDetailsList"] as List? ?? [];

    return FarmerGroupProfit(
      farmPlanId: json["farmPlanId"],
      saleValue: json["saleValue"],
      outstandingLoanAmount: json["outstandingLoanAmount"],
      vendorPayments: json["vendorPayments"],
      palCommission: json["palCommission"],
      balanceToGroup: json["balanceToFarmerGrp"],
      farmerDetails: list.map((e) => FarmerProfitDetails.fromJson(e)).toList(),
    );
  }
}

class FarmerProfitDetails {
  final String farmerName;
  final String contribution;
  final String profit;

  FarmerProfitDetails({
    required this.farmerName,
    required this.contribution,
    required this.profit,
  });

  factory FarmerProfitDetails.fromJson(Map<String, dynamic> json) {
    return FarmerProfitDetails(
      farmerName: json["farmerName"] ?? "",
      contribution: json["farmerContribution"] ?? "0",
      profit: json["profit"] ?? "0",
    );
  }
}
