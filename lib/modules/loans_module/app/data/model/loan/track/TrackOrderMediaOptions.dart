class TrackOrderMediaOptions {
  TrackOrderMediaOptions({
      this.mediaAction, 
      this.key, 
      this.value, 
      this.addiData, 
      this.fieldType, 
      this.fieldValue, 
      this.isSelected,});

  TrackOrderMediaOptions.fromJson(dynamic json) {
    mediaAction = json['mediaAction'];
    key = json['key'];
    value = json['value'];
    addiData = json['addiData'];
    fieldType = json['fieldType'];
    fieldValue = json['fieldValue'];
    isSelected = json['isSelected'];
  }
  dynamic mediaAction;
  dynamic key;
  String? value;
  String? addiData;
  dynamic fieldType;
  dynamic fieldValue;
  bool? isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mediaAction'] = mediaAction;
    map['key'] = key;
    map['value'] = value;
    map['addiData'] = addiData;
    map['fieldType'] = fieldType;
    map['fieldValue'] = fieldValue;
    map['isSelected'] = isSelected;
    return map;
  }

}