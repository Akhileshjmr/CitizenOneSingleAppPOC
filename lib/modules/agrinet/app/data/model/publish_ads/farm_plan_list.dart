import '../user/select_option.dart';

class FarmPlanListResponse {
  final List<SelectOption>? selectOptionList;

  FarmPlanListResponse({this.selectOptionList});

  factory FarmPlanListResponse.fromJson(Map<String, dynamic> json) {
    return FarmPlanListResponse(
      selectOptionList:
          json['selectOptionList'] != null
              ? (json['selectOptionList'] as List)
                  .map((item) => SelectOption.fromJson(item))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "selectOptionList": selectOptionList?.map((e) => e.toJson()).toList(),
  };
}
