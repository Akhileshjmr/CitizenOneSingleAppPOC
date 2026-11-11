class CollateralPoolNameList {
  String? collateralCode;
  String? collateralName;

  CollateralPoolNameList({
    this.collateralCode,
    this.collateralName,
  });

  factory CollateralPoolNameList.fromJson(Map<String, dynamic> json) {
    return CollateralPoolNameList(
      collateralCode: json['collateralCode'],
      collateralName: json['collateralName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collateralCode': collateralCode,
      'collateralName': collateralName,
    };
  }
}

