class ServiceRequestDetls {
  String? serviceReqId;
  String? serviceReqName;
  String? serviceReqType;

  ServiceRequestDetls({
    this.serviceReqId,
    this.serviceReqName,
    this.serviceReqType,
  });

  factory ServiceRequestDetls.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDetls(
      serviceReqId: json['serviceReqId'],
      serviceReqName: json['serviceReqName'],
      serviceReqType: json['serviceReqType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceReqId': serviceReqId,
      'serviceReqName': serviceReqName,
      'serviceReqType': serviceReqType,
    };
  }
}