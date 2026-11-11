class AgriFormerGroupListResponse {
  List<AgriFormerGroup>? agriFormerList;

  AgriFormerGroupListResponse({this.agriFormerList});

  factory AgriFormerGroupListResponse.fromJson(json) {
    return AgriFormerGroupListResponse(
      agriFormerList:
          json['agriFormerList'] != null
              ? List<AgriFormerGroup>.from(
                json['agriFormerList'].map((x) => AgriFormerGroup.fromJson(x)),
              )
              : null,
    );
  }
}

class AgriFormerGroup {
  String? grpName;
  String? descPriction;
  List<Former>? formerList;

  AgriFormerGroup({this.grpName, this.descPriction, this.formerList});

  factory AgriFormerGroup.fromJson(Map<String, dynamic> json) {
    return AgriFormerGroup(
      grpName: json['grpName'],
      descPriction: json['descPriction'],
      formerList:
          json['formerList'] != null
              ? List<Former>.from(
                json['formerList'].map((x) => Former.fromJson(x)),
              )
              : null,
    );
  }
}

class Former {
  bool? isLeader;
  Farmer? farmer;

  Former({this.isLeader, this.farmer});

  factory Former.fromJson(Map<String, dynamic> json) {
    return Former(
      isLeader: json['isLeader'],
      farmer: json['farmer'] != null ? Farmer.fromJson(json['farmer']) : null,
    );
  }
}

class Farmer {
  int? id;
  String? friendlyType;

  Farmer({this.id, this.friendlyType});

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(id: json['id'], friendlyType: json['friendlyType']);
  }
}
