import 'GdbProductGroup.dart';

class GdbProductGroupResponse {
  String? responseCode;
  String? responseDesc;
  List<GdbProductGroup>? productGroupList;

  GdbProductGroupResponse({
    this.responseCode,
    this.responseDesc,
    this.productGroupList,
  });

  factory GdbProductGroupResponse.fromJson(Map<String, dynamic> json) {
    return GdbProductGroupResponse(
      responseCode: json['responseCode'],
      responseDesc: json['responseDesc'],
      productGroupList: (json['productGroupList'] as List<dynamic>?)
          ?.map((e) => GdbProductGroup.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'responseDesc': responseDesc,
      'productGroupList': productGroupList?.map((e) => e.toJson()).toList(),
    };
  }
}
