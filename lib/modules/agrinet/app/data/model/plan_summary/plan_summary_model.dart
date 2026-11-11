import '../common/ch_message.dart';

class PlanSummaryResponse {
  final ChMessage? chMessage;
  final List<FarmPlan>? farmPlanList;

  PlanSummaryResponse({this.chMessage, this.farmPlanList});

  factory PlanSummaryResponse.fromJson(Map<String, dynamic> json) {
    return PlanSummaryResponse(
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      farmPlanList:
          (json['farmPlanList'] as List?)
              ?.map((e) => FarmPlan.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FarmPlan {
  final Plan? plan;
  final FarmerGroup? farmerGroup;
  final List<Expense>? expense;
  final Crop? crop;

  FarmPlan({this.plan, this.farmerGroup, this.expense, this.crop});

  factory FarmPlan.fromJson(Map<String, dynamic> json) {
    return FarmPlan(
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      farmerGroup:
          json['farmerGroup'] != null
              ? FarmerGroup.fromJson(json['farmerGroup'])
              : null,
      expense:
          (json['expense'] as List?)
              ?.map((e) => Expense.fromJson(e))
              .toList() ??
          [],
      crop: json['crop'] != null ? Crop.fromJson(json['crop']) : null,
    );
  }
}

class Plan {
  final String? planId;
  final String? name;
  final String? createdDate;
  final String? status;
  final String? budgetVal;

  Plan({this.planId, this.name, this.createdDate, this.status, this.budgetVal});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json['planId'],
      name: json['name'],
      createdDate: json['createdDate'],
      status: json['status'],
      budgetVal: json['budgetVal'],
    );
  }
}

class FarmerGroup {
  final String? code;
  final String? name;
  final int? noOfFarmers;
  final double? totalLandArea;

  FarmerGroup({this.code, this.name, this.noOfFarmers, this.totalLandArea});

  factory FarmerGroup.fromJson(Map<String, dynamic> json) {
    return FarmerGroup(
      code: json['code'],
      name: json['name'],
      noOfFarmers: json['noOfFarmers'],
      totalLandArea: (json['totalLandArea'] as num?)?.toDouble(),
    );
  }
}

class Expense {
  final String? type;
  final String? value;
  final String? expenseDate;

  Expense({this.type, this.value, this.expenseDate});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      type: json['type'],
      value: json['value'],
      expenseDate: json['expenseDate'],
    );
  }
}

class Crop {
  final String? cropName;
  final String? estimatedYield;

  Crop({this.cropName, this.estimatedYield});

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      cropName: json['cropName'],
      estimatedYield: json['estimatedYield'],
    );
  }
}
