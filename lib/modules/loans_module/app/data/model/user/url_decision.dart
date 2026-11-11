class UrlDecision {
  final String? actionType;
  final String? tempName;
  final String? redirUrl;

  UrlDecision({this.actionType, this.tempName, this.redirUrl});

  factory UrlDecision.fromJson(Map<String, dynamic> json) {
    return UrlDecision(
      actionType: json['actionType'] as String?,
      tempName: json['tempName'] as String?,
      redirUrl: json['redirUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'actionType': actionType,
    'tempName': tempName,
    'redirUrl': redirUrl,
  };
}
