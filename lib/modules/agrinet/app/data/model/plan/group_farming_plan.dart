class GroupFarmingPlanList {
  final List<FarmingPlanItem> plans;

  GroupFarmingPlanList({required this.plans});

  factory GroupFarmingPlanList.fromJson(Map<String, dynamic> json) {
    final list = json["selectAppStatus"]?[0]?["agriFramdet"] as List? ?? [];

    return GroupFarmingPlanList(
      plans: list.map((e) => FarmingPlanItem.fromJson(e)).toList(),
    );
  }
}

class FarmingPlanItem {
  final String groupName;
  final String planId;
  final String appStatus;

  FarmingPlanItem({
    required this.groupName,
    required this.planId,
    required this.appStatus,
  });

  factory FarmingPlanItem.fromJson(Map<String, dynamic> json) {
    return FarmingPlanItem(
      groupName: json["groupName"] ?? "",
      planId: json["planId"] ?? "",
      appStatus: json["appStatus"] ?? "",
    );
  }
}
