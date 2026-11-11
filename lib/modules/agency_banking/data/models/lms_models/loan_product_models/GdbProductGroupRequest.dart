class GdbProductGroupRequest {
  String? userName;
  String? reqSeqKey;

  GdbProductGroupRequest({
    this.userName,
    this.reqSeqKey,
  });

  factory GdbProductGroupRequest.fromJson(Map<String, dynamic> json) {
    return GdbProductGroupRequest(
      userName: json['userName'],
      reqSeqKey: json['reqSeqKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'reqSeqKey': reqSeqKey,
    };
  }
}
