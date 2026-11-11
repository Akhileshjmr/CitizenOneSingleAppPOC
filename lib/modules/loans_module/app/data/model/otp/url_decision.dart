class UrlDecision {
  UrlDecision({
      this.actionType, 
      this.tempName, 
      this.redirUrl,});

  UrlDecision.fromJson(dynamic json) {
    actionType = json['actionType'];
    tempName = json['tempName'];
    redirUrl = json['redirUrl'];
  }
  String? actionType;
  String? tempName;
  String? redirUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['actionType'] = actionType;
    map['tempName'] = tempName;
    map['redirUrl'] = redirUrl;
    return map;
  }

}