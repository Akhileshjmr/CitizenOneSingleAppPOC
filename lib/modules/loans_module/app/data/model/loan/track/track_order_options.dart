import 'TrackOrderMediaOptions.dart';

class TrackOrderOptions {
  List<TrackOrderMediaOptions>? mediaAction;
  String? key;
  String? value;
  String? addiData;
  dynamic? fieldType;
  dynamic? fieldValue;
  bool isSelected = false;

  TrackOrderOptions({
    this.mediaAction,
    this.key,
    this.value,
    this.addiData,
    this.fieldType,
    this.fieldValue,
    this.isSelected = false,
  });

  @override
  String toString() {
    return 'TrackOrderOptions{mediaAction: $mediaAction, key: $key, value: $value, addiData: $addiData, fieldType: $fieldType, fieldValue: $fieldValue, isSelected: $isSelected}';
  }

  TrackOrderOptions.fromJson(Map<String, dynamic> json) {
    mediaAction =
        json["mediaAction"] == null
            ? []
            : List<TrackOrderMediaOptions>.from(
              json["mediaAction"].map(
                (x) => TrackOrderMediaOptions.fromJson(x),
              ),
            );
    key = json['key'];
    value = json['value'];
    addiData = json['addiData'];
    fieldType = json['fieldType'];
    fieldValue = json['fieldValue'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaAction'] = this.mediaAction;
    data['key'] = this.key;
    data['value'] = this.value;
    data['addiData'] = this.addiData;
    data['fieldType'] = this.fieldType;
    data['fieldValue'] = this.fieldValue;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
