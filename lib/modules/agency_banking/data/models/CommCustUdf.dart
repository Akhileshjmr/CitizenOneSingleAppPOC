class CommCustUdf {
  String? fieldKey;
  String? fieldValue;

  CommCustUdf({this.fieldKey, this.fieldValue});

  // Deserialize from JSON
  factory CommCustUdf.fromJson(Map<String, dynamic> json) {
    return CommCustUdf(
      fieldKey: json['fieldKey'],
      fieldValue: json['fieldValue'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'fieldKey': fieldKey,
      'fieldValue': fieldValue,
    };
  }

  // Copy method (equivalent to `Parcel` methods in Java)
  factory CommCustUdf.fromParcel(Map<String, dynamic> parcel) {
    return CommCustUdf(
      fieldKey: parcel['fieldKey'],
      fieldValue: parcel['fieldValue'],
    );
  }

  Map<String, dynamic> toParcel() {
    return {
      'fieldKey': fieldKey,
      'fieldValue': fieldValue,
    };
  }
}