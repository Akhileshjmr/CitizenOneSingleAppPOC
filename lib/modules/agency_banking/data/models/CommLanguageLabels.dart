import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommLanguageLabels {
  HeaderInfo headerInfo;
  ServerMessage resMessage;
  String language;
  String screen_name;
  String label_id;
  Map<String, String> getlabelList;

  // Constructor
  CommLanguageLabels({
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
    this.language = '',
    this.screen_name = '',
    this.label_id = '',
    Map<String, String>? getlabelList,
  })  : headerInfo = headerInfo ?? HeaderInfo(),
        resMessage = resMessage ?? ServerMessage(),
        getlabelList = getlabelList ?? {};

  // Factory constructor to create an instance from JSON
  factory CommLanguageLabels.fromJson(Map<String, dynamic> json) {
    return CommLanguageLabels(
      headerInfo: json['headerInfo'] != null ? HeaderInfo.fromJson(json['headerInfo']) : HeaderInfo(),
      resMessage: json['resMessage'] != null ? ServerMessage.fromJson(json['resMessage']) : ServerMessage(),
      language: json['language'] ?? '',
      screen_name: json['screen_name'] ?? '',
      label_id: json['label_id'] ?? '',
      getlabelList: (json['getlabelList'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value.toString())) ?? {},
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo.toJson(),
      'resMessage': resMessage.toJson(),
      'language': language,
      'screen_name': screen_name,
      'label_id': label_id,
      'getlabelList': getlabelList,
    };
  }
}
